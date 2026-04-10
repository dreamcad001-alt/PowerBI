import boto3

def lambda_handler(event, context):
    s3 = boto3.client('s3')
    bucket_name = "${var.bucket_name}-${var.env}-212"
    key = "Orders.xlsx"

    response = s3.get_object(Bucket=bucket_name, Key=key)
    data = response['Body'].read().decode('utf-8')

    print("Data from S3:", data)
    return {
        'statusCode': 200,
        'body': data
    }