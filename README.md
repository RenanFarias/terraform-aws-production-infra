## Architecture

This project demonstrates a production-style AWS network architecture.

Components currently implemented:

- VPC
- Public subnet
- Private subnet
- Internet Gateway
- Route table for internet access

Architecture overview:

Internet
   │
Internet Gateway
   │
Public Subnet
   │
Application Load Balancer (future)

Private Subnet
   │
Application services (future)