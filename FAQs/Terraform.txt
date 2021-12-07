- What is null resource?
The primary use-case for the null resource is as a do-nothing container for arbitrary actions taken by a provisioner.
As the description writes, you use it mostly with provisioners such as local-exec and remote-exec

- terraform lock
- terraform force-unlock
- terraform statefile
- What are locals in terraform:
Terraform locals are named values that you can refer to in your configuration. You can use local values to simplify your Terraform configuration and avoid repetition

- commands used in statefile:
terraform statelist [options] [address]
i.e terraform state list aws_instance.bar
    terraform state list module.elb
terraform state mv [options] SOURCE DESTINATION
i.e terraform state mv 'packet_device.main' 'packet_device.all[0]'

terraform state pull
This command will download the state from its current location, upgrade the local copy to the latest state file version that is compatible with locally-installed Terraform, and output the raw format to stdout.

terraform state push [options] PATH
The terraform state push command is used to manually upload a local state file to remote state. This command also works with local state.
