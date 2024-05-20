## USAGE:

This module allows you to manage AWS Organization
By default this module can be used to:
  * create a new Organization
  * create one or more top level Organizational Units
  * create one or more AWS account, add them to the Organization and to an OU

It can also be used to create one or more OU in an existing Organization by setting var.new_org = false and var.org_root_id = "root_id"

It can also be used to create one or more AWS account in OUs managed outside terraform by setting var.unmanaged_accounts = true and the var.aws_accounts_info["ou_id] = "ou_id".

When no var.aws_accounts_info["email] is set, the module will create a new AWS account with the email "master_account_email+aws_account_name@domain_name"


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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | additional tags | `map(string)` | `{}` | no |
| <a name="input_aws_accounts_info"></a> [aws\_accounts\_info](#input\_aws\_accounts\_info) | aws account email, OU\_name, OU\_ID, close\_on\_deletion | <pre>map(object({<br>    email   = optional(string, "")<br>    ou_name = optional(string, "")<br>    ou_id   = optional(string, "")<br>    cod     = optional(bool, false) // close_on_deletion<br>    }<br>  ))</pre> | `{}` | no |
| <a name="input_close_on_deletion"></a> [close\_on\_deletion](#input\_close\_on\_deletion) | close account when removed from Org | `bool` | `false` | no |
| <a name="input_enabled_policy_types"></a> [enabled\_policy\_types](#input\_enabled\_policy\_types) | default enabled policy types | `list(string)` | <pre>[<br>  "TAG_POLICY",<br>  "SERVICE_CONTROL_POLICY"<br>]</pre> | no |
| <a name="input_master_account_email"></a> [master\_account\_email](#input\_master\_account\_email) | master account email, required if new\_org is false | `string` | `""` | no |
| <a name="input_new_org"></a> [new\_org](#input\_new\_org) | value to control creation of new organization | `bool` | `true` | no |
| <a name="input_org_principals"></a> [org\_principals](#input\_org\_principals) | values of aws\_service\_access\_principals | `list(string)` | <pre>[<br>  "cloudtrail.amazonaws.com",<br>  "config.amazonaws.com"<br>]</pre> | no |
| <a name="input_org_root_id"></a> [org\_root\_id](#input\_org\_root\_id) | existing organization root id | `string` | `null` | no |
| <a name="input_organizational_units"></a> [organizational\_units](#input\_organizational\_units) | list of OU to be created | `list(string)` | `[]` | no |
| <a name="input_unmanaged_ou"></a> [unmanaged\_ou](#input\_unmanaged\_ou) | when OU is managed outside terraform, set this to true | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_account_details"></a> [aws\_account\_details](#output\_aws\_account\_details) | account details and arn |
| <a name="output_master_account_email"></a> [master\_account\_email](#output\_master\_account\_email) | n/a |
| <a name="output_member_account_emails"></a> [member\_account\_emails](#output\_member\_account\_emails) | n/a |
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
  source = "mkomlaetou/organization/aws"

  organizational_units = var.organizational_units
  aws_accounts_info    = var.aws_accounts_info
  additional_tags      = var.additional_tags
}


// VARIABLES
variable "organizational_units" {
  default = ["GLOBAL", "DEV", "STAGING", "PROD", "SECURITY", "RETIRED"]
}


variable "aws_accounts_info" {
  default = {
    xyz-aws-dev = {
      ou_name = "RETIRED",
      email   = "xyz@gmail.com",
      cod     = true
    }

    xyz-aws-staging = {
      ou_name = "STAGING",
      cod     = true
    }

    xyz-aws-production = {
      ou_name = "PROD",
      cod     = true
    }
  }
}

variable "additional_tags" {
  default = {
    environment     = "management"
  }
}

// OUTPUTS
output "ou_details" {
  value       = module.xyz_org.ou_details
}

output "account_details" {
  value       = module.xyz_org.account_details
}

output "org_details" {
  value = module.xyz_org.org_details
}



```