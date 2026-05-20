# Much To Do - Full Stack Application

A full-stack task management application with React frontend and Golang backend, deployed on AWS with a complete CI/CD pipeline.

## Application Structure
much-to-do/
├── .github/workflows/
│   ├── frontend-ci-cd.yml    # React build and S3 deployment
│   └── backend-ci-cd.yml     # Golang build and EC2 deployment
├── Client/                   # React frontend (Vite + TypeScript)
├── Server/
│   └── MuchToDo/             # Golang backend (Gin framework)
│       ├── cmd/api/          # Application entry point
│       ├── internal/         # Business logic
│       └── Dockerfile        # Container definition
├── scripts/
│   ├── deploy-frontend.sh    # Frontend deployment script
│   ├── deploy-backend.sh     # Backend deployment script
│   ├── health-check.sh       # Health verification script
│   └── rollback.sh           # Rollback script
└── README.md

## Tech Stack

### Frontend
- React 19 with TypeScript
- Vite build tool
- TanStack Router and Query
- Tailwind CSS
- Deployed to S3 + CloudFront

### Backend
- Golang with Gin framework
- JWT authentication
- Redis for session caching
- MongoDB for data persistence
- Deployed to EC2 via Docker + ECR

## CI/CD Pipelines

### Frontend Pipeline (`frontend-ci-cd.yml`)
Triggers on push to `feature/full-stack` when files in `Client/` change:
1. Install Node.js dependencies
2. Run ESLint
3. Security scan with npm audit
4. Build production bundle
5. Sync to S3 bucket
6. Invalidate CloudFront cache

### Backend Pipeline (`backend-ci-cd.yml`)
Triggers on push to `feature/full-stack` when files in `Server/` change:
1. Run unit tests
2. Run integration tests
3. Build Docker image
4. Scan for vulnerabilities with Trivy
5. Push to Amazon ECR
6. Deploy to EC2 via SSM rolling update
7. Run smoke test against `/health`

## Required GitHub Secrets

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS IAM access key |
| `AWS_SECRET_ACCESS_KEY` | AWS IAM secret key |
| `S3_BUCKET_NAME` | `starttech-frontend-prod-106143` |
| `CLOUDFRONT_DISTRIBUTION_ID` | `E1QM9G6ELHAAXD` |
| `CLOUDFRONT_DOMAIN` | `dqaf2c5baahft.cloudfront.net` |
| `ALB_DNS_NAME` | ALB DNS for smoke tests |
| `ASG_NAME` | `starttech-asg` |
| `VITE_API_URL` | Backend API URL for frontend build |
| `MONGODB_URI` | MongoDB Atlas connection string |

## Local Development

### Frontend
```bash
cd Client
npm install
npm run dev
```

### Backend
```bash
cd Server/MuchToDo
cp .env.example .env  # configure your env vars
make run
```

### With Docker
```bash
cd Server/MuchToDo
docker-compose up -d
```

## Environment Variables

### Backend (.env)
MONGO_URI=mongodb+srv://...
REDIS_ADDR=localhost:6379
JWT_SECRET=your-secret-key
PORT=8080

## Deployment URLs

| Service | URL |
|---------|-----|
| Frontend | https://dqaf2c5baahft.cloudfront.net |
| Backend API | http://starttech-alb-1836606467.eu-west-2.elb.amazonaws.com |