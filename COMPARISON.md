# COMPARISON.md

## Azure Strengths

### 1. Zone Redundancy Without Subnet Duplication

Azure subnets are not tied to a single Availability Zone the way AWS subnets are. Redundancy and high availability are handled at the resource level instead, through the `zones` parameter on Application Gateway and the `high_availability` block on Postgres Flexible Server, rather than by duplicating a subnet per AZ for every tier. In this build that meant one subnet per tier was enough, with zone redundancy configured directly on the gateway and the database rather than doubling the VNet's subnet count the way the AWS architecture required.

### 2. Native WAF Integration

Application Gateway bundles a Web Application Firewall directly into the load balancing layer, using the OWASP managed rule set in Prevention mode, so there is no need to deploy WAF as separate infrastructure sitting in front of or beside the load balancer. It is wired in as a policy attached straight to the gateway resource. Getting equivalent edge protection on AWS means standing up and integrating a separate WAF resource, which is more infrastructure to provision and keep in sync with the load balancer it protects.

## AWS Strengths

### 1. Database Provisioning Simplicity

RDS needs a subnet group and a security group to be up and running. Postgres Flexible Server needed subnet delegation, a private DNS zone, and a DNS to VNet link just to get basic private connectivity working, three additional resources to reach the same starting point RDS gets to with two. For a database that is meant to sit privately in its own subnet and be reachable only from the app tier, Azure asked for meaningfully more setup to arrive at the same outcome.

### 2. IAM Granularity

AWS IAM policies scope access precisely to specific actions and resources on a given entity. Azure's equivalent tends to be coarser in practice. Making the app tier's managed identity an Active Directory administrator on the Postgres server was the only turnkey option available through Terraform, and that is an all or nothing grant. A properly scoped equivalent, limited to specific schemas or tables, would require native Postgres role and grant SQL run directly against the database, entirely outside what the `azurerm` provider can do. AWS gets you the fine-grained version natively, with no extra plumbing required.

## Recommendation

Although Azure was faster to provision, I would recommend AWS for a new project.

IAM granularity matters a lot for security, and being able to scope access precisely to specific resources without reaching for out of band tooling is a real advantage, especially as a system grows past a single database. Database provisioning was also noticeably simpler for the same functionality Flexible Server was providing. On top of that, working through AWS's networking forces a deeper understanding of how traffic actually moves: implementing route tables, security groups scoped to specific resources, and tracing the path from the Internet Gateway down to a database sitting in an isolated subnet. Azure offers the same functionality through NSGs, but more of that path is abstracted away from the developer by default.

I would normally weigh cost and high availability heavily in this kind of decision, but this specific comparison does not give me clean data on either. For cost, the AWS build used two Application Load Balancers, one external facing and one internal, while the Azure build used a single Application Gateway with a WAF policy attached. That is not an equivalent comparison. More load balancer resources on the AWS side, but added firewall capability on the Azure side, so it does not tell me anything reliable about relative cost for matched architectures. For high availability, Azure gets zone redundancy by default since its subnets are not locked to a single AZ, while the AWS architecture achieves the same goal more explicitly, by replicating each subnet across two Availability Zones. Both approaches reach high availability, just through different amounts of manual design work, so I am treating this as a wash rather than a point in either direction.

AWS also has a broader ecosystem and more mature tooling around Terraform modules compared to Azure. That said, for someone just starting to learn how cloud infrastructure fits together, Azure's higher level of abstraction can be the gentler starting point, and for a team that is already invested in the Azure ecosystem, that existing familiarity would reasonably outweigh the points above.
