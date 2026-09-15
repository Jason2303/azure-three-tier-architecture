# AWS to Azure Service Mapping

This document maps each AWS service used in the three-tier architecture to its Azure equivalent, with side-by-side comparisons of how each pair actually differs in behavior — not just naming.


## Summary Table

|AWS Service|Azure Equivalent|
|-|-|
|VPC|Virtual Network (VNet)|
|EC2|Virtual Machines|
|Auto Scaling Group|Virtual Machine Scale Sets (VMSS)|
|Application Load Balancer|Application Gateway|
|RDS (PostgreSQL)|Azure Database for PostgreSQL|
|Security Groups|Network Security Groups (NSGs)|
|NAT Gateway|Azure NAT Gateway|
|IAM Roles|Managed Identities|


## VPC vs VNet

|AWS VPC|Azure VNet|
|-|-|
|Subnets are strictly bound to a single Availability Zone. Once tied to an AZ, a subnet cannot switch. If that AZ goes down, the subnet goes down with it|A single subnet can span all Availability Zones within the assigned region|
|Resources are cut off from the internet by default|All resources have outbound internet access by default, no gateway required|
|Resources cannot reach the internet unless placed in a public subnet, or routed through a NAT Gateway|Resources reach the public internet through Public IP assignments, system routes, or an Azure NAT Gateway|
|An Internet Gateway is required for any internet access into or out of the VPC (or a NAT Gateway in a public subnet, for private-subnet resources)|No gateway resource exists at the network level. Internet visibility is a property of individual resources|
|Controls internal communication with Security Groups (stateful, instance level) and NACLs (stateless, subnet level)|Relies on Network Security Groups, applicable at both the NIC level and the subnet level|
|Automatically generates a Default VPC (`172.31.0.0/16`) with public subnets in every region|Does not create a default VNet. Every VNet must be explicitly configured|
|Internal traffic is managed via Route Tables assigned to subnets|Uses System Routes, customizable via User-Defined Routes|




## EC2 vs Virtual Machines

|AWS EC2|Azure Virtual Machines|
|-|-|
|Best suited to open-source, Linux-heavy architectures|Best suited to Windows enterprise environments (Windows Server, Active Directory)|
|Built primarily on the AWS Nitro System|Built on Hyper-V hardware virtualization|
|Relies on Availability Zones for fault tolerance|Offers Availability Sets, guarding against hardware failure within the same data center via fault and update domains|
|Auto Scaling Groups support dynamic, scheduled, **and predictive** scaling|Virtual Machine Scale Sets support dynamic and scheduled scaling, but lack predictive scaling|
|Instance Store (ephemeral storage) is physically attached to the host. Data is lost if the instance stops|Ephemeral storage is automatically provisioned, but data persists through standard reboots|




## ALB vs Application Gateway

|AWS ALB|Azure Application Gateway|
|-|-|
|Uses dynamic IP addresses|Uses a static Public Virtual IP (VIP)|
|Spans multiple subnets, requiring one dedicated subnet per Availability Zone|Deployed into a single, dedicated regional subnet that itself spans multiple Availability Zones|
|Must be manually configured to integrate with AWS WAF|WAF is available natively as an integrated SKU tier (WAF v2)|
|Supports routing by path, host, HTTP headers, cookies, query parameters, and source IP|Supports routing by path, host, redirection, and URL rewriting|
|Used with EC2 instances, Lambda functions, and containers (ECS/EKS)|Used with VMs, VM Scale Sets, App Services, and containers|




## RDS vs Azure Database for PostgreSQL

|AWS RDS|Azure Database for PostgreSQL|
|-|-|
|Tightly coupled with AWS-native infrastructure (S3, Lambda, IAM)|Natively integrates with Microsoft Entra ID, Azure DevOps, and .NET|
|Multi-AZ synchronous replication with automated failover|Zone-redundant HA architecture with automated standby management|
|Requires an external service i.e AWS RDS Proxy, to manage connection pooling between the application and the database|Ships with built-in integration for pgBouncer as a connection pooler|
|More cost-effective at medium-to-large scale, particularly with Reserved Instances|More cost-effective for small or burstable workloads|




## Security Groups vs Network Security Groups

|AWS Security Groups|Azure Network Security Groups|
|-|-|
|Applied at the instance level|Applied at the subnet level or the individual NIC level|
|Allow rules only. Everything else is implicitly denied|Supports both explicit allow and explicit deny rules|
|Every rule is evaluated|Rules are evaluated in priority order, first match wins|
|Can reference other security groups as a source or destination by Security Group ID|Can combine with Application Security Groups for tag-based grouping, achieving a similar reference-based effect|
|Limit of 60 rules per Security Group|Limit of 1,000 rules per Network Security Group|




## NAT Gateway vs Azure NAT Gateway

|AWS NAT Gateway|Azure NAT Gateway|
|-|-|
|Tied to a specific Availability Zone|Can span multiple zones|
|Requires deploying multiple NAT Gateways to achieve high availability|One NAT Gateway can associate with multiple subnets across different AZs in the same region|
|Subnet route tables must be manually updated to direct traffic to the NAT Gateway|Once attached to a subnet, it overrides the default outbound behavior automatically|
|Each NAT Gateway supports exactly one public Elastic IP|Each NAT Gateway supports up to 16 public IP addresses|
|Supports up to 55,000 concurrent connections per gateway|Scales up to roughly 1 million concurrent connections by adding up to 16 IPs|
|Can be public (outbound internet) or private (inter-VPC traffic)|Public only. Designed exclusively for outbound traffic|




## IAM Roles vs Managed Identities

|AWS IAM Roles|Azure Managed Identities|
|-|-|
|Delegates temporary permissions to trusted entities|Provides an automatically managed identity exclusively for Azure resources to authenticate securely|
|A role's lifecycle is independent of the resource using it|Can be System-Assigned (tied directly to the resource's own lifecycle) or User-Assigned (an independent, standalone resource)|
|Permissions are attached directly to the role via inline or managed JSON policies|Identities are created in Microsoft Entra ID; permissions are assigned via Azure RBAC at a specific scope|
|Relies on the Security Token Service API (`AssumeRole`) to fetch short-lived credentials|Relies on the internal Azure Instance Metadata Service (IMDS) identity endpoint to acquire tokens|



