## USAGE:

This module allows you to manage AWS Organization
By default this module can be used to:
  * create a new Organization
  * create one or more top level Organizational Units
  * create one or more AWS account, add them to the Organization and to an OU
  * create one or more scp policies and attach them to OUs, AWS accounts or Organization

It can also be used to create one or more OU in an non-managed Organization by setting var.new_org = false and var.org_root_id = "root_id"

You can also use this module to create one or more AWS account in OUs managed outside terraform by setting  the var.aws_accounts_info.acc_name["ou_id] = "ou_id".

When no var.aws_accounts_info.acc_name["email] is set, the module will automatically generate an email "master_account_email+aws_account_name@domain_name" for the AWS Account.


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_organizations_account.aws_acc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_account) | resource |
| [aws_organizations_organization.org](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organization) | resource |
| [aws_organizations_organizational_unit.org_ou](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) | resource |
| [aws_organizations_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) | resource |
| [aws_organizations_policy_attachment.acc_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) | resource |
| [aws_organizations_policy_attachment.ou_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) | resource |
| [aws_organizations_policy_attachment.root_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | additional tags | `map(string)` | `{}` | no |
| <a name="input_aws_accounts_info"></a> [aws\_accounts\_info](#input\_aws\_accounts\_info) | aws account email, OU\_name, OU\_ID, close\_on\_deletion | <pre>map(object({<br>    email   = optional(string, "")  // must be unique, but if not set, will be auto-generated<br>    ou_name = optional(string, "")  // required if OU is managed by terraform<br>    ou_id   = optional(string, "")  // required if OU is not managed by terraform<br>    cod     = optional(bool, false) // close_on_deletion<br>    }<br>  ))</pre> | `{}` | no |
| <a name="input_enabled_policy_types"></a> [enabled\_policy\_types](#input\_enabled\_policy\_types) | default enabled policy types | `list(string)` | <pre>[<br>  "SERVICE_CONTROL_POLICY"<br>]</pre> | no |
| <a name="input_master_account_email"></a> [master\_account\_email](#input\_master\_account\_email) | master account email, required if new\_org is false | `string` | `""` | no |
| <a name="input_new_org"></a> [new\_org](#input\_new\_org) | value to control creation of new organization | `bool` | `true` | no |
| <a name="input_org_principals"></a> [org\_principals](#input\_org\_principals) | values of aws\_service\_access\_principals | `list(string)` | <pre>[<br>  "cloudtrail.amazonaws.com",<br>  "config.amazonaws.com"<br>]</pre> | no |
| <a name="input_org_root_id"></a> [org\_root\_id](#input\_org\_root\_id) | existing organization root id | `string` | `null` | no |
| <a name="input_organizational_units"></a> [organizational\_units](#input\_organizational\_units) | list of OU to be created using terraform | `list(string)` | `[]` | no |
| <a name="input_scp_policies"></a> [scp\_policies](#input\_scp\_policies) | n/a | <pre>map(object({<br>    managed_root     = optional(bool, false)                   // if true, policy will be attached to the terraform managed root OU<br>    managed_ou_name  = optional(list(string), [])              // required if policy must be attached to terraform managed OUs<br>    managed_acc_name = optional(list(string), [])              // required if policy must be attached to terraform managed accounts<br>    policy_file_path = optional(string, "/policies/none.json") // scp policy file path<br>    }<br>  ))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_account_details"></a> [aws\_account\_details](#output\_aws\_account\_details) | account details and arn |
| <a name="output_org_details"></a> [org\_details](#output\_org\_details) | org id, master account id and master account email |
| <a name="output_ou_details"></a> [ou\_details](#output\_ou\_details) | Organizational Unit detail |



## SAMPLE CODE

```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}


// MODULE CALL
module "xyz_org" {
  source  = "mkomlaetou/organization/aws"
  version = "1.1.2"

  organizational_units = var.organizational_units
  additional_tags      = var.additional_tags
  aws_accounts_info    = var.aws_accounts_info
  scp_policies         = var.scp_policies
}


// VARIABLES
// OUs to be created
variable "organizational_units" {
  type    = list(string)
  default = [
       "GLOBAL",
       "DEV",
       "STAGING",
       "PROD",
       "SECURITY",
       "RETIRED"
   ]
}


// AWS accounts to be created
variable "aws_accounts_info" {
  default = {
    xyz-aws-dev = {
      ou_name = "DEV",
      email   = "xyz+xdev@gmail.com",
      cod     = true
    }

    xyz-aws-staging = {
      ou_name = "STAGING",
      cod     = true
    }

    xyz-aws-projects = {
      cod = true
    }

    xyz-aws-manual = {
      cod = true
      ou_id = "ou-rnut-hk28m8s4"
    }
  }
}


// Associate policies to OUs or Accounts
variable "scp_policies" {
  default = {
    dev_limit = {
      policy_file_path = "/policies/dev_region_limit.json"
      managed_ou_name  = ["DEV"]
    }

    stg-limit = {
      policy_file_path = "/policies/stg_region_limit.json"
      managed_ou_name  = ["STAGING"]
    }

    prod-limit = {
      policy_file_path = "/policies/prod_region_limit.json"
      managed_acc_name = ["xyz-aws-projects"]
      managed_ou_name  = ["PROD", "SECURITY"]
    }

    all-limit = {
      policy_file_path = "/policies/all_region_limit.json"
      managed_root     = true
    }
  }

}


// Additional tags to be added to all resources
variable "additional_tags" {
  type = map(string)
  default = {
    Environment = "PROD"
  }
}


output "ou_details" {
  description = "Organizational Unit detail"
  value       = module.xyz_org.ou_details
}

output "aws_account_details" {
  description = "account details and arn"
  value       = module.xyz_org.aws_account_details

}

output "org_details" {
  value = module.xyz_org.org_details
}





```
