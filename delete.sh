# principal stack
aws cloudformation delete-stack --stack-name cicd-volatile-principal --region eu-west-1
aws cloudformation wait stack-delete-complete --stack-name cicd-volatile-principal --region eu-west-1

# resources stack
# aws cloudformation delete-stack --stack-name cicd-volatile-resources --region eu-west-1
# aws cloudformation wait stack-delete-complete --stack-name cicd-volatile-resources --region eu-west-1
