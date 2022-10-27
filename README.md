# Introduction
This repo is being used to spawn any aws specific resources for ONDC project

# for whom
anyone who wants to use infrastructure as code for spawning databases, vms, s3 etc

# how to use it
export AWS_PROFILE=ondc-prod
# this you can skip if we are mentioning in env.hcl
export AWS_DEFAULT_REGION=ap-south-1
# this is the most important property, since we name s3 table conataining 
export TG_BUCKET_PREFIX=ondc-prod-

# currently supporting
1) Ec2
2) RDS
3) S3
4) default subnet/vpc
