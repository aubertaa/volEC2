# resources stack
# aws cloudformation deploy --no-fail-on-empty-changeset --stack-name cicd-volatile-resources --template-file 01_resources.yaml --region=eu-west-1 --capabilities CAPABILITY_NAMED_IAM --tags Team=cicd Billing=global

# principal stack
aws cloudformation deploy --no-fail-on-empty-changeset --stack-name cicd-volatile-principal --template-file 02_principal.yaml --region=eu-west-1 --capabilities CAPABILITY_NAMED_IAM --tags Team=cicd Billing=global --parameter-overrides ResourcesStack=cicd-volatile-resources

# get sg id
SG_ID=$(aws cloudformation describe-stacks --stack-name cicd-volatile-principal --query "Stacks[0].Outputs[?OutputKey=='VolatileEnvSecurityGroupID'].OutputValue" --region eu-west-1 --output text)
echo "Security group ID is : ${SG_ID}"

#get public IP
PUBLIC_IP=$(aws cloudformation describe-stacks --stack-name cicd-volatile-principal --query "Stacks[0].Outputs[?OutputKey=='VolatileEnvEC2PublicIP'].OutputValue" --region eu-west-1 --output text)
echo "Public ip is : ${PUBLIC_IP}"

# authorize EC2 to call its own docker registry
aws ec2 authorize-security-group-ingress --group-id ${SG_ID} --protocol tcp --port 5005 --cidr ${PUBLIC_IP}/32
aws ec2 authorize-security-group-ingress --group-id ${SG_ID} --protocol tcp --port 3000 --cidr ${PUBLIC_IP}/32
aws ec2 authorize-security-group-ingress --group-id ${SG_ID} --protocol tcp --port 8084 --cidr ${PUBLIC_IP}/32
echo "Access to local registry and meteo app is now authorized."

# aws ec2 authorize-security-group-ingress --group-id sg-0567677d057e23308 --protocol tcp --port 5005 --cidr 54.154.112.108/32
# aws ec2 authorize-security-group-ingress --group-id sg-0567677d057e23308 --protocol tcp --port 3000 --cidr 54.154.112.108/32
# aws ec2 authorize-security-group-ingress --group-id sg-0567677d057e23308 --protocol tcp --port 8080 --cidr 54.154.112.108/32


# get KeyPair  (to activate only if keypair is part of the deployment (DEV_CICD for now)
# aws ssm get-parameter --name /ec2/keypair/VolatileEnvKeyPair --region eu-west-1 --with-decryption
