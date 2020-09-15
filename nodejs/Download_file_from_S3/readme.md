# Download File from S3

[![theeye.io](../images/logo-theeye-theOeye-logo2.png)](https://theeye.io/en/index.html)

### Download File with the possibility of deleting the same file from AWS S3 with AWS-SDK MODULE.

### Dependencies

aws-sdk

#### Task Arguments

input | key |
fixed | Delete after download | true

#### Environment Variables:

AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
AWS_S3_BUCKET
DOWNLOADED_PATH

### Example:

{
  "AWS_ACCESS_KEY_ID": "123id",
  "AWS_SECRET_ACCESS_KEY": "123secretkey",
  "AWS_REGION": "us-east-1",
  "AWS_S3_BUCKET": "s3bucket",
  "DOWNLOADED_PATH": "downloadpath"
}

