# Upload File to S3

[![theeye.io](../images/logo-theeye-theOeye-logo2.png)](https://theeye.io/en/index.html)

### This task receive a path as a parameter and upload the files from that directory to an AWS S3

### Dependencies

aws-sdk

#### Task Arguments

input | path

#### Environment Variables:

AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
AWS_S3_BUCKET
UPLOADED_PATH
AWS_S3_BUCKET_DIRECTORY

### Example:

{
  "AWS_ACCESS_KEY_ID": "d123das",
  "AWS_SECRET_ACCESS_KEY": "R+asdfasdf",
  "AWS_REGION": "us-east-1",
  "AWS_S3_BUCKET": "ttt-aa.ee.com",
  "AWS_S3_BUCKET_DIRECTORY": "input/work",
  "UPLOADED_PATH": "/mnt/data/uploadedFiles"
}




