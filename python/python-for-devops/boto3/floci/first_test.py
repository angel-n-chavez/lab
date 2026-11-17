import boto3
from botocore.exceptions import ClientError

# Using seesion I dont need a floci client helper function
session = boto3.Session(profile_name="floci")
s3 = session.client("s3")

try:
    create_bucket = s3.create_bucket(
        Bucket="boto3-floci-test",
        CreateBucketConfiguration={
            "Tags": [
                {"Key": "Test", "Value": "Floci"},
            ]
        },
    )
except ClientError as e:
    if e.response.get("Error", {}).get("Code") == "BucketAlreadyOwnedByYou":
        print("Error Message: {}".format(e.response.get("Error", {}).get("Message")))
    else:
        raise

# when working with unpredictible APIs use get() instead of square brackets
# prevents KeyErrors
list_buckets = s3.list_buckets()
for bucket in list_buckets.get("Buckets", []):
    print(f"Bucket Name: {bucket.get('Name')}")
    print(f"Bucket Created: {bucket.get('CreationDate')}")
    print(
        f"Bucket Arn: {bucket.get('BucketArn')}"
    )  # without get() this would throw a KeyError, because BucketArn is a new API addition and Floci will not recognize it.
