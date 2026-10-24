import re, sys, time, pathlib, boto3

REGION = "ap-southeast-2"
BUCKET = "flowmatrix-lake-418059030267"
OUTPUT = f"s3://{BUCKET}/athena-results/"
athena = boto3.client("athena", region_name=REGION)
s3 = boto3.client("s3", region_name=REGION)


def run(sql, name):
    qid = athena.start_query_execution(
        QueryString=sql,
        ResultConfiguration={"OutputLocation": OUTPUT},
    )["QueryExecutionId"]
    while True:
        status = athena.get_query_execution(QueryExecutionId=qid)["QueryExecution"]["Status"]
        if status["State"] in ("SUCCEEDED", "FAILED", "CANCELLED"):
            break
        time.sleep(1)
    if status["State"] != "SUCCEEDED":
        sys.exit(f"FAILED {name}: {status.get('StateChangeReason')}")
    print(f"OK {name}")


def empty_prefix(prefix):
    # Safety guard: only silver/ and gold/ may ever be wiped, never bronze
    assert prefix.startswith(("silver/", "gold/")), f"refusing to delete {prefix}"
    for page in s3.get_paginator("list_objects_v2").paginate(Bucket=BUCKET, Prefix=prefix):
        keys = [{"Key": o["Key"]} for o in page.get("Contents", [])]
        if keys:
            s3.delete_objects(Bucket=BUCKET, Delete={"Objects": keys})


def reset_if_ctas(sql, name):
    table = re.search(r"CREATE TABLE\s+(\S+)", sql, re.I)
    loc = re.search(r"external_location\s*=\s*'s3://[^/]+/([^']+)'", sql, re.I)
    if table and loc:
        run(f"DROP TABLE IF EXISTS {table.group(1)}", f"drop {table.group(1)}")
        empty_prefix(loc.group(1))


folders = sys.argv[1:] or ["sql"]
for folder in folders:
    for f in sorted(pathlib.Path(folder).rglob("*.sql")):
        sql = f.read_text()
        reset_if_ctas(sql, str(f))
        run(sql, str(f))