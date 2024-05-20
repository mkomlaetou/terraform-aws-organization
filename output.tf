

output "org_details" {
  description = "org id, master account id and master account email"
  value = {
    org_id = aws_organizations_organization.org[0].id
    master_account_id = aws_organizations_organization.org[0].master_account_id
    master_account_email = aws_organizations_organization.org[0].master_account_email
  }
}

output "ou_details" {
  description = "Organizational Unit detail"
  value       = { for k, ou in aws_organizations_organizational_unit.org_ou : k => { "id" = ou.id, "arn" = ou.arn } }
}

output "aws_account_details"{
  description = "account details and arn"
  value = {for k, acc in aws_organizations_account.aws_acc : k => {"id" = acc.id, "arn" = acc.arn}}

}
