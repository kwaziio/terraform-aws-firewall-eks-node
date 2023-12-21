# Complete Usage Example

This example is intended to show a standard use case for this module with a moderate amount of customization; it also includes the creation of all prerequisite resources:

```HCL
###########################
# Terraform Configuration #
###########################

terraform {
  required_version = ">= 1.6.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.21"
    }
  }
}

##############################
# AWS Provider Configuration #
##############################

provider "aws" {
  // DO NOT HARDCODE CREDENTIALS (Use Environment Variables)
}

###################################
# Required Prerequisite Resources #
###################################

module "network" {
  source = "kwaziio/network/aws"

  network_primary_cidr_block = "10.0.0.0/16"
  network_tags_name          = "example-network"
  network_trusted_ipv4_cidrs = ["0.0.0.0/0"]

  subnets_private = [
    {
      cidr = "10.0.0.0/19",
      name = "private-a",
      zone = "a",
    },
    {
      cidr = "10.0.32.0/19",
      name = "private-b",
      zone = "b",
    },
    {
      cidr = "10.0.64.0/19",
      name = "private-c",
      zone = "c",
    },
  ]

  subnets_public = [
    {
      cidr = "10.0.192.0/20",
      name = "public-a",
      zone = "a",
    },
    {
      cidr = "10.0.208.0/20",
      name = "public-b",
      zone = "b",
    },
    {
      cidr = "10.0.224.0/20",
      name = "public-c",
      zone = "c",
    },
  ]
}

##################################
# Example Terraform Module Usage #
##################################

module "terraform_aws_firewall_eks_node" {
  source = "../../"

  network_id = module.network.network_id
}
```

## Executing Example Deployment

The following example is provided as guidance, but can also be used for integration testing:

* [https://github.com/kwaziio/terraform-aws-firewall-eks-node/tree/main/examples/complete](https://github.com/kwaziio/terraform-aws-firewall-eks-node/tree/main/examples/complete)

### Deploying Complete Example as Integration Test

The following commands will initialize and deploy the infrastructure for the complete example:

```SHELL
terraform -chdir=examples/complete init -reconfigure
terraform -chdir=examples/complete apply
```

### Destroying Complete Example After Integration Test

The following command will destroy any resources created while deploying the complete example:

```SHELL
terraform -chdir=examples/complete destroy
```
