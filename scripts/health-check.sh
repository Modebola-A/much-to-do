#!/bin/bash
set -e

# Usage: ./health-check.sh <alb-dns-name>
ALB_DNS=${1:-$ALB_DNS_NAME}
MAX_RETRIES=10
RETRY_INTERVAL=15

if [ -z "$ALB_DNS" ]; then
  echo "❌ Error: ALB DNS name required"
  echo "Usage: ./health-check.sh <alb-dns>"
  exit 1
fi

echo "� Running health check against http://$ALB_DNS/health"

for i in $(seq 1 $MAX_RETRIES); do
  echo "   Attempt $i/$MAX_RETRIES..."

  STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
    --connect-timeout 10 \
    http://$ALB_DNS/health || echo "000")

  if [ "$STATUS" = "200" ]; then
    echo "��✅ Health check passed (HTTP $STATUS)"
    exit 0
  fi

  echo "   ⚠️  Got HTTP $STATUS — retrying in ${RETRY_INTERVAL}s..."
  sleep $RETRY_INTERVAL
done

echo "❌ Health check failed after $MAX_RETRIES attempts"
exit 1
