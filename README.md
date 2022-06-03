export AWS_PROFILE=ondc-prod
# this you can skip if we are mentioning in env.hcl
export AWS_DEFAULT_REGION=ap-south-1
# this is the most important property, since we name s3 table conataining 
export TG_BUCKET_PREFIX=ondc-prod-