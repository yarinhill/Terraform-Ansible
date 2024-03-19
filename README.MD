# Build Jenkins Master and Worker on AWS with Terraform & Ansible

## Installation Process

### 1.
Install Terraform & Ansible on your Workstation

### 2. 
Create s3 bucket for Terraform Backend

```
aws s3api create-bucket --bucket <YOUR_BUCKET_NAME> --region <YOUR_REGION> --acl private --create-bucket-configuration LocationConstraint=<YOUR_REGION>
```

### 3. 
Edit the backend.tf with the s3 Bucket you created

```
vim backend.tf
```

### 4.
Create IAM in AWS with the following Permissions

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CustomPolicyForTF",
            "Action": [
                "acm:*",
                "elasticloadbalancing:AddListenerCertificates",
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:CreateListener",
                "elasticloadbalancing:CreateLoadBalancer",
                "elasticloadbalancing:CreateRule",
                "elasticloadbalancing:CreateTargetGroup",
                "elasticloadbalancing:DeleteListener",
                "elasticloadbalancing:DeleteLoadBalancer",
                "elasticloadbalancing:DeleteRule",
                "elasticloadbalancing:DeleteTargetGroup",
                "elasticloadbalancing:DeregisterTargets",
                "elasticloadbalancing:DescribeListenerCertificates",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeRules",
                "elasticloadbalancing:DescribeSSLPolicies",
                "elasticloadbalancing:DescribeTags",
                "elasticloadbalancing:DescribeTargetGroupAttributes",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticloadbalancing:ModifyListener",
                "elasticloadbalancing:ModifyLoadBalancerAttributes",
                "elasticloadbalancing:ModifyRule",
                "elasticloadbalancing:ModifyTargetGroup",
                "elasticloadbalancing:ModifyTargetGroupAttributes",
                "elasticloadbalancing:RegisterTargets",
                "elasticloadbalancing:RemoveListenerCertificates",
                "elasticloadbalancing:RemoveTags",
                "elasticloadbalancing:SetSecurityGroups",
                "elasticloadbalancing:SetSubnets",
                "route53:Get*",
                "route53:List*",
                "route53:ChangeResourceRecordSets",
                "ssm:Describe*",
                "ssm:GetParameter",
                "ssm:GetParameters",
                "ssm:GetParametersByPath",
                "s3:CreateBucket",
                "s3:DeleteBucket",
                "s3:DeleteObject",
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:PutObject",
                "ec2:Describe*",
                "ec2:Get*",
                "ec2:AcceptVpcPeeringConnection",
                "ec2:AttachInternetGateway",
                "ec2:AssociateRouteTable",
                "ec2:AuthorizeSecurityGroupEgress",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CreateInternetGateway",
                "ec2:CreateNetworkAcl",
                "ec2:CreateNetworkAclEntry",
                "ec2:CreateRoute",
                "ec2:CreateRouteTable",
                "ec2:CreateSecurityGroup",
                "ec2:CreateSubnet",
                "ec2:CreateTags",
                "ec2:CreateVpc",
                "ec2:CreateVpcPeeringConnection",
                "ec2:DeleteNetworkAcl",
                "ec2:DeleteNetworkAclEntry",
                "ec2:DeleteRoute",
                "ec2:DeleteRouteTable",
                "ec2:DeleteSecurityGroup",
                "ec2:DeleteSubnet",
                "ec2:DeleteTags",
                "ec2:DeleteVpc",
                "ec2:DeleteVpcPeeringConnection",
                "ec2:DetachInternetGateway",
                "ec2:DisassociateRouteTable",
                "ec2:DisassociateSubnetCidrBlock",
                "ec2:CreateKeyPair",
                "ec2:DeleteKeyPair",
                "ec2:DeleteInternetGateway",
                "ec2:ImportKeyPair",
                "ec2:ModifySubnetAttribute",
                "ec2:ModifyVpcAttribute",
                "ec2:ModifyVpcPeeringConnectionOptions",
                "ec2:RejectVpcPeeringConnection",
                "ec2:ReplaceNetworkAclAssociation",
                "ec2:ReplaceNetworkAclEntry",
                "ec2:ReplaceRoute",
                "ec2:ReplaceRouteTableAssociation",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:RevokeSecurityGroupIngress",
                "ec2:RunInstances",
                "ec2:TerminateInstances",
                "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
                "ec2:UpdateSecurityGroupRuleDescriptionsIngress"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
```

### 5. 
Add the IAM access key & secret key to the Workstation

```
aws configure
```

### 6.
Install Python3 on the Workstation

```
sudo apt-get install python3
sudo apt-get install python3-boto3
```

## Configuration Process

### 1.
Edit the variables.tf file to suit your environment

```
vim variables.tf
```

### 2.
Change AWS AMI if needed ( If you did, adjust the ansible_templates/jenkins-*-sample.yml files and replace yum with the package manager of your AMI )

Line 1
``` 
vim instances.tf
```

### 3.
Edit the tf_aws_ec2.yml with the regions of your choice

Line 11
```
vim ansible_templates/inventory_aws/tf_aws_ec2.yml
```

## Building Process

### 1.
Run the following commands to initialize, validate and plan the terraform files

```
terraform init
terraform validate
terraform plan
```

### 2.
Finally, Run terraform apply

```
terraform apply
```

### 3.
Browse to the Load Balancer DNS provided in the end of the terraform apply command (LB-DNS-NAME)
```
http://<LB-DNS-NAME>
```
