variable "org_principals" {
  description = "values of aws_service_access_principals"
  type        = list(string)
  default     = ["cloudtrail.amazonaws.com", "config.amazonaws.com", ]
}


variable "enabled_policy_types" {
  description = "default enabled policy types"
  type        = list(string)
  default     = ["SERVICE_CONTROL_POLICY"]
}


variable "new_org" {
  description = "value to control creation of new organization"
  type        = bool
  default     = true
}

variable "org_root_id" {
  description = "existing organization root id"
  type        = string
  default     = null
}


variable "organizational_units" {
  description = "list of OU to be created using terraform"
  type        = list(string)
  default     = []
}


variable "aws_accounts_info" {
  description = "aws account email, OU_name, OU_ID, close_on_deletion"
  type = map(object({
    email   = optional(string, "")  // must be unique, but if not set, will be auto-generated
    ou_name = optional(string, "")  // required if OU is managed by terraform
    ou_id   = optional(string, "")  // required if OU is not managed by terraform
    cod     = optional(bool, false) // close_on_deletion
    }
  ))
  default = {}
}

variable "master_account_email" {
  description = "master account email, required if new_org is false"
  type        = string
  default     = ""
}


variable "additional_tags" {
  description = "additional tags"
  type        = map(string)
  default     = {}
}


variable "scp_policies" {
  type = map(object({
    managed_root     = optional(bool, false)                   // if true, policy will be attached to the terraform managed root OU
    managed_ou_name  = optional(list(string), [])              // required if policy must be attached to terraform managed OUs
    managed_acc_name = optional(list(string), [])              // required if policy must be attached to terraform managed accounts
    policy_file_path = optional(string, "/policies/none.json") // scp policy file path
    }
  ))
  default = {}
}

