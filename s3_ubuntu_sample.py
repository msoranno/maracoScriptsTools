#!/usr/bin/python
from boto3.session import Session

key_id='AKIAJXVTNHATUQ4MTX4A'
secre_id='TcYE26lQOJJmZ0PsZaBC58wTrRw4Af4P5zchBXfW'
session = Session(aws_access_key_id = key_id, aws_secret_access_key = secre_id)
s3 = session.resource('s3')
#s3.create_bucket(Bucket='bucketcreatedfrompythonoutside')

for bucket in s3.buckets.all():
	print bucket
#delete
# bucket = s3.Bucket('maraco-bucket-1')
# bucket.delete()
