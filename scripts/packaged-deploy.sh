date=`date +%Y-%m-%d-%H-%M-%S`
#Reemplazar por bucket para los templates
bucket="fullm-0000-app-ap-00-templates"
prefix="templates/lambda-reboot/$date"
outputfile="master-package.yaml"

#Change
profile="default"
region="us-east-1"
stackname="FULLM-0000-APP-AP-00-Scheduler"

#SAM Package
echo "SAM Package"
sam package  \
--template-file template.yaml \
--s3-bucket $bucket \
--s3-prefix $prefix \
--output-template-file "packaged/$outputfile" \
--profile $profile \
--region $region

echo "Upload packaged to S3"
aws s3 cp packaged/$outputfile s3://$bucket/$prefix/$outputfile --profile $profile --region $region
echo "https://$bucket.s3.amazonaws.com/$prefix/$outputfile"

echo "SAM Deploy"
sam deploy \
--template-file ./packaged/master-package.yaml \
--stack-name $stackname \
--capabilities "CAPABILITY_NAMED_IAM" \
--profile $profile \
--region $region \
--force-upload