terraform {
    backend s3 {
        bucket = "terraform_backup_for_myfiles"
        key = "statefile.tfstate"
        region = "us-east-1"
        encrypt = true

    }
}