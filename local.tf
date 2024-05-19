locals {
  default_tags = {
    IACTool = "terraform"
  }

  tags = merge(local.default_tags, var.additional_tags)
}




# import {
#   id = "o-731rbjckbt"
#   to = aws_organizations_organization.org[0]
# }