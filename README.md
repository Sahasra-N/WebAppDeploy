# Application Deployment to AWS App Runner using Terraform

This repository contains the infrastructure code to deploy an application to AWS App Runner using Terraform. The application code (CSS, JavaScript, HTML) is stored in a GitHub repository, and the pipeline is set up in Azure DevOps.

## Prerequisites

Before you begin, ensure you have the following installed:
- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://aws.amazon.com/cli/)
- [Azure DevOps CLI](https://docs.microsoft.com/en-us/azure/devops/cli/?view=azure-devops)
- [Docker](https://www.docker.com/get-started)
- Create S3 and ECR 
- S3 for terraform state
- ECR to store container images
## Setup Instructions

### 1. Clone the Repository

Clone your GitHub repository to your local machine:

```bash
git clone https://github.com/Sahasra-N/WebAppDeploy.git
cd WebAppDeploy
