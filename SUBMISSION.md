# Assessment Submission


## Repository URLs

- Application Repository: https://github.com/Modebola-A/much-to-do/tree/feature/full-stack
- Infrastructure Repository: https://github.com/Modebola-A/starttech-infra

## AWS Console Access

- Console Login URL: https://106143845072.signin.aws.amazon.com/console
- IAM Username: starttech-cicd
- Password: [share this privately with your assessor, not in this file]

## AWS Resources Created

| Resource | Name/ID |
|----------|---------|
| Region | eu-west-2 (London) |
| VPC | starttech-vpc |
| ALB | starttech-alb-1836606467.eu-west-2.elb.amazonaws.com |
| ASG | starttech-asg |
| S3 Bucket | starttech-frontend-prod-106143 |
| CloudFront | E1QM9G6ELHAAXD / dqaf2c5baahft.cloudfront.net |
| ElastiCache | starttech-redis |
| ECR | starttech-backend |
| MongoDB | starttech-cluster (Atlas, eu-west-1) |

## CI/CD Pipelines

| Pipeline | File | Trigger |
|----------|------|---------|
| Frontend | .github/workflows/frontend-ci-cd.yml | Push to feature/full-stack (Client/) |
| Backend | .github/workflows/backend-ci-cd.yml | Push to feature/full-stack (Server/) |
| Infrastructure | .github/workflows/infrastructure-deploy.yml | Push to main (terraform/) |

## Architecture

- Frontend: React (Vite + TypeScript) → S3 + CloudFront
- Backend: Golang (Gin) → Docker → ECR → EC2 (ASG + ALB)
- Cache: ElastiCache Redis (eu-west-2)
- Database: MongoDB Atlas (eu-west-1)
- IaC: Terraform with modular structure
