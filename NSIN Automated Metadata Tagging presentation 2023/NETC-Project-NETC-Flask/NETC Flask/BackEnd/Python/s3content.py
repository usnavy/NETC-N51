import boto3
from flask import session

ACCESS_KEY = 'NA'
SECRET_KEY = 'NA'

BUCKET_NAME = 'netc-filestorage'

def _get_s3_resource():
        return boto3.resource(
            's3',
            aws_access_key_id=ACCESS_KEY,
            aws_secret_access_key=SECRET_KEY
        )
   


def get_bucket():
    s3_resource = _get_s3_resource()
    if 'bucket' in session:
        bucket = session['bucket']
    else:
        bucket = BUCKET_NAME

    return s3_resource.Bucket(bucket)

