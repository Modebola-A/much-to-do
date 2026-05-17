#!/bin/bash
set -e

# Usage: ./deploy-backend.sh <image-tag> <asg-name>
IMAGE_TAG=${1:-$IMAGE_TAG}
ASG_NAME=${2:-$ASG_NAME}
AWS_REGION=${AWS_REGION:-eu-west-2}

if [ -z "$IMAGE_TAG" ] || [ -z "$ASG_NAME" ]; then
  echo "‚ùå Error: Image tag and ASG name required"
  echo "Usage: ./deploy-backend.sh <image-tag> <asg-name>"
  exit 1
fi

echo "Ì Starting rolling deployment..."
echo "   Image: $IMAGE_TAG"
echo "   ASG:   $ASG_NAME"

# Get all running instance IDs in the ASG
INSTANCE_IDS=$(aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names "$ASG_NAME" \
  --query 'AutoScalingGroups[0].Instances[?LifecycleState==`InService`].InstanceId' \
  --output text \
  --region $AWS_REGION)

if [ -z "$INSTANCE_IDS" ]; then
  echo "∫Ä‚ùå No instances found in ASG: $ASG_NAME"
  exit 1
fi

echo "Ì Found instances: $INSTANCE_IDS"

# Deploy to each instance one at a time (rolling)
for INSTANCE_ID in $INSTANCE_IDS; do
  echo "≥ã‚è≥ Deploying to $INSTANCE_ID..."

  COMMAND_ID=$(aws ssm send-command \
    --instance-ids "$INSTANCE_ID" \
    --document-name "AWS-RunShellScript" \
    --parameters "commands=[
      'aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $(echo $IMAGE_TAG | cut -d/ -f1)',
      'docker pull $IMAGE_TAG',
      'docker stop backend || true',
      'docker rm backend || true',
      'docker run -d --name backend --restart always -p 8080:8080 --env-file /etc/app/.env $IMAGE_TAG',
      'sleep 10',
      'docker ps | grep backend'
    ]" \
    --region $AWS_REGION \
    --query 'Command.CommandId' \
    --output text)

  echo "   SSM Command ID: $COMMAND_ID"
  echo "‚úÖ Deployed to $INSTANCE_ID"
done

echo "‚úÖ Rolling deployment complete"
