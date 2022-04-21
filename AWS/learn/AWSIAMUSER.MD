Identity and Access Management(IAM) is used to manage AWS

Users
Groups
Roles
Api Keys
IAM Access Policies
and it provide method for secure access/access-permissions to AWS resources(such as EC2,S3, etc)

Now go to the IAM console https://us-east-1.console.aws.amazon.com/iamv2/home?region=us-east-1#/home

If we notice at the right hand side at the top of console it says Global i.e creating a user/groups/roles will apply to all regions


To create a new user,Just click on Users on the left navbar and then click on Add users


and then add all the details


By default any new IAM account created with NO access to any AWS services(non-explicit deny)

Always follow the best practice and for daily work try to use a account with least privilege(i.e non root user)


IAM Policies: A policy is a document that formally states one or more permissions.For eg: IAM provides some pre-built policy templates to assign to users and groups

Administrator access: Full access to AWS resources
Power user access: Admin access except it doesn’t allow user/group management
Read only access: As name suggest user can only view AWS resources
Default policy is explicitly deny which will override any explicitly allow policy


Let take a look at these policies

AdministratorAccess

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
We can create our own custom policy using policy generator or written from scratch


So Custom Policy where everything denies for EC2 resources


More than one policy can be attached to a user or group at the same time
Policy cannot be directly attached to AWS resources(eg: EC2 instance)
There is a really nice tool https://policysim.aws.amazon.com which we can use to test and troubleshoot IAM and resource based policies
Skip tagging and Review all the setting and click on Create user


Now we understand how to create the user manually, let automate the process
