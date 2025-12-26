#!/usr/bin/env bash

USG_CIS_PROFILE=$(aws ssm get-parameter --name usg_cis_profile --query Parameter.Value --with-decryption --output text)
S3_BUCKET=$(aws ssm get-parameter --name s3bucket --query Parameter.Value --with-decryption --output text)


usg audit "$USG_CIS_PROFILE" --html-file results.html --results-file results.xml --oval-results

aws s3api put-object \
    --bucket "$S3_BUCKET" \
    --key usg/results.html \
    --body results.html
