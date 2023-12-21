#######################################
# Locally-Available Dynamic Variables #
#######################################

locals {
  sg_prefix = coalesce(var.firewall_prefix, try("${data.aws_vpc.selected.tags["Name"]}-", ""))
}

#########################################################
# Retrieves Information About the Targeted VPC Instance #
#########################################################

data "aws_vpc" "selected" {
  id = var.network_id
}

##########################################################
# Creates AWS Virtual Private Cloud (VPC) Security Group #
##########################################################

resource "aws_security_group" "eks_node" {
  description = "Manages All Firewall Rules for EKS Worker Nodes"
  name        = "${local.sg_prefix}${var.firewall_name}"
  vpc_id      = var.network_id

  tags = merge({
    Application = "kubernetes"
    Component   = "cluster"
    Name        = "${local.sg_prefix}${var.firewall_name}"
  }, var.resource_tags)
}

###################################################################
# Creates Default VPC Security Group Rule for IPv4 Egress Traffic #
###################################################################

resource "aws_vpc_security_group_egress_rule" "eks_node_all_ipv4" {
  cidr_ipv4   = var.firewall_allowed_ipv4_egress_cidrs[count.index]
  count       = length(var.firewall_allowed_ipv4_egress_cidrs)
  description = "Allows Egress via All Ports and Protocols Based on Destination CIDR"
  ip_protocol = "-1"
  security_group_id = aws_security_group.eks_node.id

  tags = {
    CIDR = var.firewall_allowed_ipv4_egress_cidrs[count.index]
    Name = "${aws_security_group.eks_node.name}-all-all-ipv4"
  }
}

###################################################################
# Creates Default VPC Security Group Rule for IPv6 Egress Traffic #
###################################################################

resource "aws_vpc_security_group_egress_rule" "eks_node_all_ipv6" {
  cidr_ipv6   = var.firewall_allowed_ipv6_egress_cidrs[count.index]
  count       = length(var.firewall_allowed_ipv6_egress_cidrs)
  description = "Allows Egress via All Ports and Protocols Based on Destination CIDR"
  ip_protocol = "-1"
  security_group_id = aws_security_group.eks_node.id

  tags = {
    CIDR = var.firewall_allowed_ipv6_egress_cidrs[count.index]
    Name = "${aws_security_group.eks_node.name}-all-all-ipv6"
  }
}

#####################################################################
# Creates VPC Security Group Rule Permitting RDP Access via Bastion #
#####################################################################

resource "aws_vpc_security_group_ingress_rule" "eks_node_tcp_rdp_bastion" {
  count                        = var.firewall_enable_bastion_access ? 1 : 0
  description                  = "Allows RDP Traffic via TCP Protocol from Bastion"
  from_port                    = var.network_default_rdp_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.firewall_bastion_id
  security_group_id            = aws_security_group.eks_node.id
  to_port                      = var.network_default_rdp_port
}

#####################################################################
# Creates VPC Security Group Rule Permitting SSH Access via Bastion #
#####################################################################

resource "aws_vpc_security_group_ingress_rule" "eks_node_tcp_ssh_bastion" {
  count                        = var.firewall_enable_bastion_access ? 1 : 0
  description                  = "Allows SSH Traffic via TCP Protocol from Bastion"
  from_port                    = var.network_default_ssh_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.firewall_bastion_id
  security_group_id            = aws_security_group.eks_node.id
  to_port                      = var.network_default_ssh_port
}
