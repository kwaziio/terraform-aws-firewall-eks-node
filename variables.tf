###########################################################################
# AWS Virtual Private Cloud (VPC) Security Group [Firewall] Configuration #
###########################################################################

variable "firewall_allowed_ipv4_egress_cidrs" {
  default     = ["0.0.0.0/0"]
  description = "List of IPv4 CIDRs to Permit All Egress Traffic via All Protocols and Ports"
  type        = list(string)
}

variable "firewall_allowed_ipv6_egress_cidrs" {
  default     = ["::/0"]
  description = "List of IPv6 CIDRs to Permit All Egress Traffic via All Protocols and Ports"
  type        = list(string)
}

variable "firewall_bastion_id" {
  default     = null
  description = "ID of the Bastion VPC Security Group (Required if Bastion Access is Enabled)"
  type        = string
}

variable "firewall_enable_bastion_access" {
  default     = true
  description = "'true' if SSH and RDP Access Should be Granted via a Bastion VPC Security Group"
  type        = bool
}

variable "firewall_name" {
  default     = "eks-node"
  description = "Name Tag and Value to Assign to VPC Security Group"
  type        = string
}

variable "firewall_prefix" {
  default     = null
  description = "Prefix to Append to VPC Security Group Name (Overrides VPC Name)"
  type        = string
}

###########################################################
# AWS Virtual Private Cloud (VPC) [Network] Configuration #
###########################################################

variable "network_default_rdp_port" {
  default     = 3389
  description = "Default RDP Port to Leverage Throughout the Created Network"
  type        = number
}

variable "network_default_ssh_port" {
  default     = 22
  description = "Default SSH Port to Leverage Throughout the Created Network"
  type        = number
}

variable "network_id" {
  description = "VPC ID to Associated w/ Created VPC Security Group"
  type        = string
}

##################################
# Created Resource Configuration #
##################################

variable "resource_tags" {
  default     = {}
  description = "Map of AWS Resource Tags to Assign to All Created Resources"
  type        = map(string)
}
