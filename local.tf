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
  member_account_emails = { for k, v in var.aws_accounts_info : k => v.email != "" ? v.email : join("@", ["${local.master_account_email[0]}+${k}", local.master_account_email[1]]) }

}


//
locals {
  managed_root_policy_attachments = {
    for k, v in var.scp_policies : k => v.managed_root == true ? {
      name      = "${k}-root"
      policy_id = aws_organizations_policy.policy[k].id
      root_id   = aws_organizations_organization.org[0].roots[0].id
  } : null }

// filter out null objects
  filtered_root_policy_attachments = {
    for k, v in local.managed_root_policy_attachments : k => v if v != null
  }
}



locals {
  ou_policy_attachments = flatten([
    for policy_key, policy_data in var.scp_policies : [
      for ou in policy_data.managed_ou_name : {
        name      = "${policy_key}-${ou}"
        policy_id = aws_organizations_policy.policy[policy_key].id
        ou_id     = aws_organizations_organizational_unit.org_ou[ou].id
      }
    ]
  ])

  managed_acc_policy_attachments = flatten([
    for policy_key, policy_data in var.scp_policies : [
      for acc in policy_data.managed_acc_name : {
        name      = "${policy_key}-${acc}"
        policy_id = aws_organizations_policy.policy[policy_key].id
        acc_id    = aws_organizations_account.aws_acc[acc].id
      }
    ]
  ])


}
