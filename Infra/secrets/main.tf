resource "aws_secretmanager_secret" "secret_manager" {
    name = "/secrets/mysecrets"
    recovery_window_in_days = 0
}