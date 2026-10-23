import sys, time, pathlib, boto3

REGION = "ap-southeast-2"
OUTPUT = "s3://flowmatrix-lake-418059030267/athena-results/"
athena = boto3.client("athena", region_name=REGION)


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


folders = sys.argv[1:] or ["sql"]
for folder in folders:
    for f in sorted(pathlib.Path(folder).rglob("*.sql")):
        run(f.read_text(), str(f))