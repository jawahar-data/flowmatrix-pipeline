import pathlib, re, sys

errors = []
files = sorted(pathlib.Path("sql").rglob("*.sql"))
if not files:
    sys.exit("no SQL files found")

for f in files:
    s = f.read_text().strip()
    layer = f.parent.name
    if not s.endswith(";") or s.count(";") != 1:
        errors.append(f"{f}: must be exactly one statement ending in ';'")
    if layer == "1_bronze" and "CREATE EXTERNAL TABLE" not in s:
        errors.append(f"{f}: bronze files must create external tables")
    if layer in ("2_silver", "3_gold"):
        want = "silver/" if layer == "2_silver" else "gold/"
        m = re.search(r"external_location\s*=\s*'s3://[^/]+/([^']+)'", s)
        if not (m and m.group(1).startswith(want)):
            errors.append(f"{f}: external_location must be under {want}")

if errors:
    print("\n".join(errors))
    sys.exit(1)
print(f"{len(files)} SQL files OK")