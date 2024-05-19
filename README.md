## USAGE:

This module allows you to manage AWS Organization
By default this module can be used to:
  * create a new Organization
  * create one or more top level Organizational Units
  * create one or more AWS account, add them to the Organization and to an OU

It can also be used to create one or more OU in an existing Organization by setting var.new_org = false and var.org_root_id = "root_id"

It can also be used to create one or more AWS account in OUs managed outside terraform by setting var.unmanaged_accounts = true and use "ou_id" instead of "ou_name" in var.aws_accounts_info.


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
| <a name="input_aws_accounts_info"></a> [aws\_accounts\_info](#input\_aws\_accounts\_info) | aws account email, OU\_name or OU\_ID, close\_on\_deletion | `map(tuple([ string, string, bool ]))` | `{}` | no |
| <a name="input_close_on_deletion"></a> [close\_on\_deletion](#input\_close\_on\_deletion) | close account when removed from Org | `bool` | `false` | no |
| <a name="input_enabled_policy_types"></a> [enabled\_policy\_types](#input\_enabled\_policy\_types) | default enabled policy types | `list(string)` | <pre>[<br>  "TAG_POLICY",<br>  "SERVICE_CONTROL_POLICY"<br>]</pre> | no |
| <a name="input_new_org"></a> [new\_org](#input\_new\_org) | value to control creation of new organization | `bool` | `true` | no |
| <a name="input_org_principals"></a> [org\_principals](#input\_org\_principals) | values of aws\_service\_access\_principals | `list(string)` | <pre>[<br>  "cloudtrail.amazonaws.com",<br>  "config.amazonaws.com"<br>]</pre> | no |
| <a name="input_org_root_id"></a> [org\_root\_id](#input\_org\_root\_id) | existing organization root id | `string` | `null` | no |
| <a name="input_organizational_units"></a> [organizational\_units](#input\_organizational\_units) | list of OU to be created | `list(string)` | `[]` | no |
| <a name="input_unmanaged_ou"></a> [unmanaged\_ou](#input\_unmanaged\_ou) | when OU is managed outside terraform, set this to true | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_details"></a> [account\_details](#output\_account\_details) | account details and arn |
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
  source = "../modules/terraform-aws-organization"

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
      "xyz-aws-dev"     = ["aws+dev@xyz.com", "DEV", true]
      "xyz-aws-staging" = ["aws+staging@xyz.com", "STAGING", true]
      "xyz-aws-prod"    = ["aws+prod@xyz.com", "PROD", true]
  }
}

variable "additional_tags" {
  default = {
    environment     = "dev"
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