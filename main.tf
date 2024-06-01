###############################
# CREATE ORG, OU, ACCOUNTS
###############################

// create an aws organization
resource "aws_organizations_organization" "org" {
  count                         = var.new_org == true ? 1 : 0
  aws_service_access_principals = var.org_principals
  feature_set                   = "ALL"
  enabled_policy_types          = var.enabled_policy_types
}


// create an organizational unit
resource "aws_organizations_organizational_unit" "org_ou" {
  for_each  = toset(var.organizational_units)
  name      = each.key
  parent_id = var.org_root_id != null ? var.org_root_id : aws_organizations_organization.org[0].roots[0].id

  tags = local.tags
}


// create an aws account under OU
resource "aws_organizations_account" "aws_acc" {
  for_each          = var.aws_accounts_info
  name              = each.key
  email             = local.member_account_emails[each.key]
  role_name         = "OrganizationAccountAccessRole"
  #parent_id         = var.unmanaged_ou == true ? each.value["ou_id"] : aws_organizations_organizational_unit.org_ou["${each.value["ou_name"]}"].id
  parent_id         = each.value["ou_name"] != "" && each.value["ou_id"] == "" ? aws_organizations_organizational_unit.org_ou["${each.value["ou_name"]}"].id : each.value["ou_name"] == "" && each.value["ou_id"] != "" ? each.value["ou_id"] : aws_organizations_organization.org[0].roots[0].id

  close_on_deletion = each.value["cod"]

  lifecycle {
    ignore_changes = [role_name]
  }
  tags = merge(local.tags, tomap({ "Name" = each.key }))

  depends_on = [aws_organizations_organizational_unit.org_ou]
}


##############################################################
# CREATE SCP POLICIES AND ATTACH POLICIES TO ORG OR OU
##############################################################

// create SCP policies
resource "aws_organizations_policy" "policy" {
  for_each = var.scp_policies
  name     = each.key
  content  = each.value["policy_file_path"] == "/policies/none.json" ? file("${path.module}${each.value["policy_file_path"]}") : file("${path.cwd}${each.value["policy_file_path"]}")

  depends_on = [ aws_organizations_account.aws_acc, aws_organizations_organizational_unit.org_ou ]
}


// attach SCP policy to organizational unit
resource "aws_organizations_policy_attachment" "ou_policy_attachment" {
  for_each  = { for idx, attachment in local.ou_policy_attachments : "${attachment.name}" => attachment }
  policy_id = each.value.policy_id
  target_id = each.value.ou_id
}

// attach SCP policy to aws account
resource "aws_organizations_policy_attachment" "acc_policy_attachment" {
  for_each  = { for idx, attachment in local.managed_acc_policy_attachments : "${attachment.name}" => attachment }
  policy_id = each.value.policy_id
  target_id = each.value.acc_id
}



// attach SCP policy to root
resource "aws_organizations_policy_attachment" "root_policy_attachment" {
  for_each = local.filtered_root_policy_attachments
  policy_id = each.value.policy_id
  target_id = each.value.root_id
}
