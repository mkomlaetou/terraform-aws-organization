locals {
  default_tags = {
    IACTool = "terraform"
  }

  tags = merge(local.default_tags, var.additional_tags)
}



locals {
  // split master account email into account name and domain name
  master_account_email = var.new_org == false ? split("@", var.master_account_email) : split("@", aws_organizations_organization.org[0].master_account_email)

  // create an email for member accounts using master account email and account name (xyz+staging@example.com)
  member_account_emails = { for k, v in var.aws_accounts_info : k =>  v.email != "" ? v.email : join("@", ["${local.master_account_email[0]}+${k}", local.master_account_email[1]])}

}
