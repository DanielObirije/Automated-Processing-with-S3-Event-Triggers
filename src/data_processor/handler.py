import json
import boto3
import urllib.parse
from datetime import datetime

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
               process_csv_file(bucket,key,file_size)
            elif key.endswith(".json"):
               process_json_file(bucket,key,file_size)
            elif key.endswith(".txt"):
               process_txt_file(bucket,key,file_size)
            else:
               print(f"Unsupported file type: {key}")
               continue
            create_processing_report(bucket,key,file_size)
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

def process_json_file(bucket, key, file_size):
    print(f"Processing CSV file: {key} (Size: {file_size} bytes)")

def process_txt_file(bucket, key, file_size):
    print(f"Processing CSV file: {key} (Size: {file_size} bytes)")

def create_processing_report(bucket, key, file_size):
    report_key = f"reports/{key}-report-{datetime.now().strftime('%Y%m%d%H%M%S')}.json"

    report = {
        "file_size": file_size,
        "procesing_time" : datetime.now().isoformat(),
        "status": "completed"
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


