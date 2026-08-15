import json
import boto3
from datetime import datetime

sns = boto3.client("sns")

def lambda_handler(event,context):
    try:
        for record in event["Records"]:
            message_body = json.loads(record["body"])

            error_message = message_body.get("erorr_message", "Unknown erorr")
            timestamp = message_body.get("timestamp", datetime.now().isoformat())
            alert_message = f"""Data Processing Error Alert Error: {error_message} Timestamp: {timestamp} Please investigate the failed processing job."""

            import os
            sns_topic_arn = os.environ.get("SNS_TOPIC_ARN")

            if sns_topic_arn:
                sns.publish(
                    TopicArn=sns_topic_arn,
                    Message=alert_message,
                    Subject="Data Processing Error Alert"
                )

            print(f"Error alert sent for: {error_message}")

    except Exception as e:
        print(f"Error in error handler: {str(e)}")
        raise
    return {
        "statusCode": 200,
        "body": json.dumps("Error handling completed")
    }