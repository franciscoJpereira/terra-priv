import boto3
from botocore.exceptions import ClientError
from os import environ


S3_BUCKET = environ.get("S3_BUCKET")

def get_object_from_event(event):
    path = event.get("path", "/")
    if path.startswith("/"):
        path = path[1:]
    if path == '':
        path = "index.html"
    return path

def get_content(event, s3_client):
    path = get_object_from_event(event)
    obj = s3_client.get_object(
        Bucket=S3_BUCKET,
        Key=path
    )
    return obj["Body"].read().decode("utf-8"), obj["ContentType"] 

def lambda_handler(event, context):
    """
    AWS Lambda function to handle incoming requests and forward them to the appropiate bucket
    """
    s3 = boto3.client("s3")
    try:
        content, content_type = get_content(event, s3)
        return {
            "statusCode": 200,
            "isBase64Encoded": 'image/' in content_type,
            "headers": {
                "Content-Type": content_type
            },
            "body": content
        }
    except ClientError as e:
        if e.response['Error']['Code'] == 'NoSuchKey':
            return {
                "statusCode": 400,
                "body": "Not Found"
            }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": str(e)
        }

