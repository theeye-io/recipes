# Upload Rar File to S3

[![theeye.io](../images/logo-theeye-theOeye-logo2.png)](https://theeye.io/en/index.html)

### Upload Rar File or Directory to AWS S3 with AWS-SDK MODULE.

### Dependencies

aws-sdk

#### Task Arguments

input |file 
fixed |type | file

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
  "AWS_S3_BUCKET": "xttxx-aa.ee.com",
  "AWS_S3_BUCKET_DIRECTORY": "input/work",
  "UPLOADED_PATH": "/mnt/data/uploadedFiles"
}

