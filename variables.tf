variable "org_principals" {
  description = "values of aws_service_access_principals"
  type        = list(string)
  default     = ["cloudtrail.amazonaws.com", "config.amazonaws.com", ]
}


variable "enabled_policy_types" {
  description = "default enabled policy types"
  type = list(string)
  default = [ "TAG_POLICY", "SERVICE_CONTROL_POLICY" ]
}


variable "close_on_deletion" {
  description = "close account when removed from Org"
  type    = bool
  default = false
}


variable "new_org" {
  description = "value to control creation of new organization"
  type = bool
  default = true
}

variable "org_root_id" {
  description = "existing organization root id"
  type = string
  default = null
}


variable "organizational_units" {
  description = "list of OU to be created"
  type    = list(string)
  default = []
}


variable "unmanaged_ou" {
  description = "when OU is managed outside terraform, set this to true"
  type = bool
  default = false
}

variable "aws_accounts_info" {
  description = "aws account email, OU_name or OU_ID, close_on_deletion"
  type = map(tuple([ string, string, bool ]))
  default = {
    # "account_name" = ["email", "ou_name or ou_id", close_on_deletion_status ] 
  }
}

variable "additional_tags" {
  description = "additional tags"
  type        = map(string)
  default     = {}
}
