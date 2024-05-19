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
