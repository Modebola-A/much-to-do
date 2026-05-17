#!/bin/bash
set -e

# Usage: ./deploy-frontend.sh <s3-bucket-name> <cloudfront-distribution-id>
S3_BUCKET=${1:-$S3_BUCKET_NAME}
CF_DISTRIBUTION=${2:-$CLOUDFRONT_DISTRIBUTION_ID}

if [ -z "$S3_BUCKET" ] || [ -z "$CF_DISTRIBUTION" ]; then
  echo "¥ó‚ùå Error: S3 bucket and CloudFront distribution ID required"
  echo "Usage: ./deploy-frontend.sh <s3-bucket> <cloudfront-id>"
  exit 1
fi

echo "Ì Deploying frontend to S3..."

# Sync all files except index.html (with long cache)
aws s3 sync Client/dist/ s3://$S3_BUCKET \
  --delete \
  --cache-control "public, max-age=31536000" \
  --exclude "index.html"

# index.html with no cache
aws s3 cp Client/dist/index.html s3://$S3_BUCKET/index.html \
  --cache-control "no-cache, no-store, must-revalidate"

echo "∫ÄÌ Invalidating CloudFront cache..."
aws cloudfront create-invalidation \
  --distribution-id $CF_DISTRIBUTION \
  --paths "/*"

echo "¥Ñ‚úÖ Frontend deployment complete"
