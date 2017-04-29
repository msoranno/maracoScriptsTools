#!/usr/bin/python
from boto3.session import Session

key_id=''
secre_id=''
session = Session(aws_access_key_id = key_id, aws_secret_access_key = secre_id)
s3 = session.resource('s3')
#s3.create_bucket(Bucket='bucketcreatedfrompythonoutside')

for bucket in s3.buckets.all():
	print bucket
#delete
# bucket = s3.Bucket('maraco-bucket-1')
# bucket.delete()
