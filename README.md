# Grafana Alert Management with Terraform

A streamlined approach to managing Grafana alerts using Infrastructure as Code (IaC) with Terraform. This repository provides automated alert configurations that are deployed via GitHub Actions.

## 📁 Repository Structure

```
terraform/
├── airflow.tf       # Airflow-specific alert configurations
├── backend.tf       # Terraform state management configuration
├── folder.tf        # Alert folder organization setup 
└── main.tf         # Primary Terraform configuration
```


## Prerequisites and Configuration


## 🔐 AWS Setup Prerequisites

### 1. S3 Bucket Creation
1. Go to AWS Console → Services → S3
2. Click "Create bucket"
3. Configure:
   - Bucket name: `your-terraform-state-bucket`
   - Region: `us-west-2`
   - Enable Versioning: ✅
   - Enable server-side encryption: ✅
   - Block all public access: ✅
   - Click "Create bucket"

### 2. IAM Policy Creation
1. Go to AWS Console → Services → IAM → Policies
2. Click "Create policy"
3. Use JSON editor and paste:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": "arn:aws:s3:::your-terraform-state-bucket"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::your-terraform-state-bucket/folder-name/terraform.tfstate"
        }
    ]
}
```
4. Name: `TerraformStatePolicyDevopsNow`

### 3. Service Account Creation
1. Go to AWS Console → Services → IAM → Users
2. Create user:
   - Name: `terraform-state-bot`
   - Access type: Programmatic access
3. Attach the `TerraformStatePolicy` policy
4. Go to view user and generate the Access key , save it


### GitHub Repository Setup

#### Required GitHub Secrets
Configure the following secrets in your repository settings:
- `AWS_ACCESS_KEY_ID`: AWS access key with necessary permissions
- `AWS_SECRET_ACCESS_KEY`: AWS secret access key
- `AWS_REGION`: AWS region (e.g., `us-west-2`)
- `GRAFANA_USERNAME`: Grafana admin/service account username
- `GRAFANA_PASSWORD`: Grafana admin/service account password

### Terraform Backend Configuration

#### S3 Remote State Management
1. Create an S3 bucket for storing Terraform state
2. Update `backend.tf`:
```hcl
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "folder-name/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
  }
}
```
### Development Workflow

####  Local Setup

Clone the repository to your local environment:
```bash
git clone <repository_url>
cd grafana-alert-code
```

### Grafana Configuration

#### Alert Rule Group Export
Two approaches for alert rule group configuration:

1. **Export Existing Rules**:
   - Navigate to Grafana instance
   - Export existing rule groups in Terraform HCL format
   - Place exported `.tf` files in the `terraform/` directory

2. **Build from Scratch**:
   - Refer to Terraform Grafana Provider documentation:
     https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group

#### Custom Grafana URL
Update `main.tf` provider configuration:
```hcl
provider "grafana" {
  url  = "https://your-custom-grafana-instance.com"
  auth = "${var.grafana_username}:${var.grafana_password}"
}
```



####  Making Changes

1. Create a new feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Navigate to the Terraform directory:
   ```bash
   cd terraform
   ```

3. Make your desired changes to the alert configurations
   For example, to change the evaluation interval of airflow.tf to 120 seconds:
   - Modify existing `.tf` files
   - Add new alert configurations
   - Update evaluation intervals or thresholds

4. Validate your changes:
   ```bash
   terraform init
   terraform plan
   ```

####  Submitting Changes

1. Commit your changes:
   ```bash
   git add .
   git commit -m "Descriptive commit message"
   git push origin feature/your-feature-name
   ```

2. Create a Pull Request:
   - Navigate to the repository on GitHub
   - Click "New Pull Request"
   - Select your feature branch
   - Provide a detailed description of your changes
   - Request reviews from team members

#### Deployment

Once your PR is approved and merged:
1. GitHub Actions will automatically trigger the deployment workflow
2. The workflow will:
   - Initialize Terraform
   - Plan the changes
   - Apply the configurations to the Grafana server

## 🔍 Verification

### Deployment Status
- Monitor the deployment progress in the GitHub Actions tab
- Check for any workflow failures or errors

### Grafana Server
Verify your changes on the Grafana server:
- Access the Grafana interface: https://your-custom-grafana-instance.com/alerting/list
- Confirm alert configurations are updated

## ⚠️NOTE

**Testing**
   - Always test changes locally before pushing
   - Use `terraform plan` to preview changes
   - Consider impact on existing alerts

## 📚 Additional Resources

- [Grafana Provisioning Examples](https://github.com/grafana/provisioning-alerting-examples/tree/main/terraform)
- [Grafana Alerting Documentation](https://grafana.com/docs/grafana/latest/alerting/set-up/provision-alerting-resources/terraform-provisioning/)
- [Grafana Cloud Terraform Guide](https://grafana.com/docs/grafana-cloud/developer-resources/infrastructure-as-code/terraform/dashboards-github-action/)
