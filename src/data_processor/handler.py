import json
import boto3
import urllib.parse
from datetime import datetime
import io
import csv

s3 = boto3.client("s3")
sqs = boto3.client("sqs")

def lambda_handler(event,context):
      try:
         for record in event["Records"]:
            bucket = record["S3"]["bucket"]["name"]
            key = urllib.parse.unquote_plus(record["S3"]["object"]["key"])
            print(f"Processing object: {key} from bucket: {bucket}")

            response = s3.head_object(Bucket=bucket, Key=key)
            file_size = response['ContentLength']

            if key.endswith(".csv"):
               processing_result = process_csv_file(bucket,key,file_size)
            elif key.endswith(".json"):
               processing_result = process_json_file(bucket,key,file_size)
            elif key.endswith(".txt"):
               processing_result = process_txt_file(bucket,key,file_size)
            else: 
               print(f"Unsupported file type: {key}")
               continue
            create_processing_report(bucket,key,file_size,processing_result)
      except Exception as e:
         print(f"Error processing S3 event: {str(e)}")
         send_to_dlq(event, str(e))
         raise e
      return {
         'statusCode': 200,
         'body': json.dumps('Successfully processed S3 events')
         }

def process_csv_file(bucket, key, file_size):
    print(f"Processing CSV file: {key} (Size: {file_size} bytes)")
    response = s3.get_object(
        Bucket=bucket,
        Key=key
    )

    content = response["Body"].read().decode("utf-8")

    csv_reader = csv.DictReader(io.StringIO(content))

    rows = list(csv_reader)

    result = {
        "file_type": "csv",
        "file_name": key,
        "rows_processed": len(rows),
        "columns": csv_reader.fieldnames,
        "size": file_size
    }

    print(result)

    return result

def process_json_file(bucket, key, file_size):
    print(f"Processing CSV file: {key} (Size: {file_size} bytes)")
    response = s3.get_object(
            Bucket=bucket,
            Key=key
        )
    content = response["Body"].read().decode("utf-8")
    data = json.loads(content)
    
    if isinstance(data, list):
            records = len(data)
    else:
        records = 1
        result = {
            "file_type": "json",
            "file_name": key,
            "records_processed": records,
            "size": file_size
        }
        print(result)
    
        return result

def process_txt_file(bucket, key, file_size):
    print(f"Processing CSV file: {key} (Size: {file_size} bytes)")
    response = s3.get_object(
        Bucket=bucket,
        Key=key
    )

    content = response["Body"].read().decode("utf-8")

    lines = content.splitlines()

    result = {
        "file_type": "txt",
        "file_name": key,
        "lines_processed": len(lines),
        "characters": len(content),
        "size": file_size
    }

    print(result)

    return result

def create_processing_report(bucket, key, file_size,processing_result):
    report_key = f"reports/{key}-report-{datetime.now().strftime('%Y%m%d%H%M%S')}.json"

    report = {
        "file_size": file_size,
        "procesing_time" : datetime.now().isoformat(),
        "status": "completed",
        "details": processing_result
    }

    s3.put_object(
        Bucket=bucket,
        Key=report_key,
        Body=json.dumps(report),
        ContentType='application/json'
    )
    print(f"Processing report created: {report_key}")
    
def send_to_dlq(event, error_message):
    import os
    dlq_url = os.environ.get("DLQ_URL")

    if dlq_url:
        message = {
            "original_event":  event,
            "error_message": error_message,
            "timestamp": datetime.now().isoformat()
        }
        sqs.send_message(
            QueueUrl=dlq_url,
            MessageBody=json.dumps(message)
        )


