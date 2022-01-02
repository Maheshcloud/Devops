The AWS CLI will look for credentials on each call in this order: command-line options, environment variables, AWS credentials file, CLI configuration file, and instance profiles. 

We can get the access_key_id and secret_access_key under # ~/.aws/config

If we want to configure two different profiles, then use below commands:

```sh
aws configure set profile.example.aws_access_key_id myid
aws configure set profile.example.aws_secret_access_key mysecret
aws configure set profile.example.region us-west-1
```

This results in the following.

```sh
# ~/.aws/config

[default]
region = us-west-1
output = json

[profile example]
region = us-west-1

# ~/.aws/credentials

[default]
aws_access_key_id = <YOUR_AWS_ACCESS_KEY>
aws_secret_access_key = <YOUR_AWS_SECRET_KEY>	

[example]
aws_access_key_id = myid
aws_secret_access_key = mysecret
```

## Delegation
Now that you understand how the AWS CLI works, you can apply that model for cross-account calls. As I said before, let’s assume that you already have two accounts called Dev and Prod. You can anticipate that most of the day-to-day development and activity happens in the Dev account, so this will be where the individual IAM user credentials are created and issued. The Prod account will be the one to which secure access is established from the privileged users in the Dev account.

After the accounts are established, perform three tasks:

Create an IAM role in your Prod account.
Create a user in your Dev account to assume that IAM role.
Establish cross-account trust and access from the user in the Dev account to the role in the Prod account.

## Task 1: Create an IAM role in your Prod account (the account that users want to sign in to)

You first will need to create an IAM role in your Prod account with a user that has privileged access to do so. This role will need with it a trust policy, which specifies who is allowed to assume the associated role. (Replace the placeholder ID with your own Dev account ID.)

```sh
prod_trust_policy.json

{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::Dev-account-ID:user/bjwagner"
      },
    "Action": "sts:AssumeRole"
  }]
}
```
With the trust policy as defined, you can create the role.

```sh
aws iam create-role 
  --role-name CrossAccountPowerUser 
  --assume-role-policy-document file://./prod_trust_policy.json 
  --profile prod
```

Running this in your terminal will produce some information about your role, including the Amazon Resource Name (ARN), which you should take note of before moving on to Task 2. The ARN should look like: “AWS”: “arn:aws:iam::Prod-account-ID:role/CrossAccountPowerUser”.

By default, IAM resources (such as roles) are created without any permissions, so you need to define what this role is capable of doing when it is assumed by attaching a policy. Attach the ReadOnlyAccess managed policy.

```sh
aws iam attach-role-policy 
  --role-name CrossAccountPowerUser 
  --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess 
  --profile prod
  
```
## Task 2: Create a user in the Dev account with permission to assume the IAM role in the Prod account
Now that you have an appropriate IAM role in place, create a policy that allows its principal to assume the role in Prod. Using the ARN returned from Task 1 as the Resource, the policy looks like the following.
```sh
dev_assume_role_prod.json

{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": "arn:aws:iam::Prod-account-ID:role/CrossAccountPowerUser"
    }
}
```
The trust policy in Task 1 only allowed the IAM user bjwagner from the Dev account to assume the role, so you will use create-policy to create an IAM managed policy that you will associate with an IAM user.

```sh
aws iam create-policy 
  --policy-name ProdAccountAccess 
  --policy-document file://./dev_assume_role_prod.json
 ```
 
 Notice that you didn’t use the –profile option. This is because without that option, the CLI will use the default credentials that were defined with aws configure, which should be configured to use the Dev account.

Upon success, this will return some information about the newly created policy. You will need to take note of the ARN that is part of the output. If you are using JSON, your output format will look similar to the following.

```sh
{
    "Policy": {
        "PolicyName": " ProdAccountAccess",
        "CreateDate": "2015-11-10T15:01:32.772Z",
        "AttachmentCount": 0,
        "IsAttachable": true,
        "PolicyId": "ANPAKSKWUJMXAERMQUNK",
        "DefaultVersionId": "v1",
        "Path": "/",
        "Arn": "arn:aws:iam::Dev-account-ID:policy/ProdAccountAccess",
        "UpdateDate": "2015-11-10T15:01:32.772Z"
    }
}
```
Using the resulting ARN, your last step for this task is to associate the newly created policy with the IAM user in the Dev account. This is achieved with the use of attach-user-policy command.

```sh
aws iam attach-user-policy 
  --user-name bjwagner 
  --policy-arn arn:aws:iam::Dev-account-ID:policy/ProdAccountAccess
```
If nothing is returned, the operation was successful. At this point you have established the permissions needed to achieve cross-account access, and now must configure the AWS CLI to utilize it.

## Task 3: Establish cross-account trust and access from the user to the role
Now set the AWS CLI to leverage these changes. To create a profile that will use the role in your Prod account, first apply it to your configuration.
'''sh
aws configure set profile.prod.role_arn arn:aws:iam::Prod-account-ID:role/CrossAccountPowerUser

aws configure set profile.prod.source_profile default
```
The first command will create a new CLI profile called prod and will append the given role_arn to ~/.aws/config. The second command sets the source_profile, which references the default credentials profile so that you can use the same IAM user for Dev and Prod.

Your ~/.aws/config file will look like the following.
```sh
# ~/.aws/config

[default]
region = us-west-1
output = json

[profile prod]
role_arn = arn:aws:iam::Prod-account-ID:role/CrossAccountPowerUser
source_profile = default
```
And the ~/.aws/credentials file will remain the same.
```sh
# ~/.aws/credentials

[default]
aws_access_key_id = <YOUR_AWS_ACCESS_KEY>
aws_secret_access_key = <YOUR_AWS_SECRET_KEY>
```
##Excercising your power
With this method, you not only keep your Prod account secure by not permitting long-term credentials, but you also manage IAM users by keeping your users in one account. So what does your workflow look like now?

Without specifying the –profile option in your AWS CLI command, you will automatically use the default profile, which is configured to interact with your Dev account using the long-term credentials that were input when calling aws configure.
```sh
aws ec2 describe-instances --region us-west-1
```
This should return your Amazon EC2 resources in your Dev account in the US West (N. California) region. With the addition of –profile prod in the same command, you should get a very different result set back, which are your EC2 resources from the Prod account in US West (N. California).
```sh
aws ec2 describe-instances --region us-west-1 --profile prod
```
By simply appending –profile prod to your command, you have told the AWS CLI to use the named profile prod, which is configured for an IAM role. The CLI will automatically make an STS:AssumeRole call and store the resulting temporary credentials in the ~/.aws/cache file. All future calls made using the same named profile will use the cached temporary credentials until they expire. When the credentials do expire, the AWS CLI will automatically repeat the process to give you fresh credentials.
