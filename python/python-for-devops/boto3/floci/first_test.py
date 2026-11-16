import boto3

def floci_client(service):
    return boto3.client(
        service,
        endpoint_url="http://floci:4566",
        region_name="us-east-1",
        aws_access_key_id="test",
        aws_secret_access_key="test",
    )


s3 = floci_client("s3")

response = s3.list_buckets()
for bucket in response.get("Buckets", []):
    print(bucket["Name"])
