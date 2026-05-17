#!/bin/bash
set -e

# Usage: ./rollback.sh <asg-name> <previous-image-tag>
ASG_NAME=${1:-$ASG_NAME}
PREVIOUS_IMAGE=${2:-$PREVIOUS_IMAGE_TAG}
AWS_REGION=${AWS_REGION:-eu-west-2}

if [ -z "$ASG_NAME" ] || [ -z "$PREVIOUS_IMAGE" ]; then
  echo "❌ Error: ASG name and previous image tag required"
  echo "Usage: ./rollback.sh <asg-name> <previous-image-tag>"
  exit 1
fi

echo "⏪ Rolling back to: $PREVIOUS_IMAGE"

INSTANCE_IDS=$(aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names "$ASG_NAME" \
  --query 'AutoScalingGroups[0].Instances[?LifecycleState==`InService`].InstanceId' \
  --output text \
  --region $AWS_REGION)

for INSTANCE_ID in $INSTANCE_IDS; do
  echo "⏳ Rolling back $INSTANCE_ID..."

  aws ssm send-command \
    --instance-ids "$INSTANCE_ID" \
    --document-name "AWS-RunShellScript" \
    --parameters "commands=[
      'docker stop backend || true',
      'docker rm backend || true',
      'docker run -d --name backend --restart always -p 8080:8080 --env-file /etc/app/.env $PREVIOUS_IMAGE',
      'sleep 10',
      'docker ps | grep backend'
    ]" \
    --region $AWS_REGION

  echo "✅ Rolled back $INSTANCE_ID"
done

echo "✅ Rollback complete — running: $PREVIOUS_IMAGE"
