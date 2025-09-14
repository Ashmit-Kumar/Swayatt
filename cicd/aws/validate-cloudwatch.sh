#!/bin/bash

# CloudWatch Monitoring Validation Script
# This script validates that CloudWatch monitoring is properly configured

echo "🔍 CloudWatch Monitoring Validation"
echo "===================================="

# Check if CloudWatch agent is installed
echo "1. Checking CloudWatch Agent Installation..."
if command -v /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl &> /dev/null; then
    echo "   ✅ CloudWatch Agent is installed"
else
    echo "   ❌ CloudWatch Agent not found"
    echo "   💡 Run: sudo ./setup-cloudwatch.sh to install"
    exit 1
fi

# Check if CloudWatch agent is running
echo "2. Checking CloudWatch Agent Status..."
if systemctl is-active --quiet amazon-cloudwatch-agent; then
    echo "   ✅ CloudWatch Agent is running"
else
    echo "   ❌ CloudWatch Agent is not running"
    echo "   💡 Run: sudo systemctl start amazon-cloudwatch-agent"
fi

# Check AWS CLI installation
echo "3. Checking AWS CLI..."
if command -v aws &> /dev/null; then
    echo "   ✅ AWS CLI is installed"
    AWS_VERSION=$(aws --version 2>&1 | cut -d/ -f2 | cut -d' ' -f1)
    echo "   📍 Version: $AWS_VERSION"
else
    echo "   ❌ AWS CLI not found"
    echo "   💡 Install with: pip install awscli"
fi

# Check AWS credentials
echo "4. Checking AWS Credentials..."
if aws sts get-caller-identity &> /dev/null; then
    echo "   ✅ AWS credentials are configured"
    ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
    REGION=$(aws configure get region)
    echo "   📍 Account: $ACCOUNT_ID"
    echo "   📍 Region: $REGION"
else
    echo "   ❌ AWS credentials not configured"
    echo "   💡 Run: aws configure"
fi

# Test CloudWatch log groups
echo "5. Checking CloudWatch Log Groups..."
LOG_GROUPS=("/aws/ec2/swayatt-app/docker" "/aws/ec2/swayatt-app/jenkins" "/aws/ec2/swayatt-app/pipeline")

for log_group in "${LOG_GROUPS[@]}"; do
    if aws logs describe-log-groups --log-group-name-prefix "$log_group" --query 'logGroups[0].logGroupName' --output text 2>/dev/null | grep -q "$log_group"; then
        echo "   ✅ Log group exists: $log_group"
    else
        echo "   ⚠️  Log group not found: $log_group"
        echo "   💡 It will be created when logs are first sent"
    fi
done

# Test sending a test log
echo "6. Testing Log Publishing..."
TEST_MESSAGE="CloudWatch validation test at $(date)"
if aws logs create-log-group --log-group-name "/aws/ec2/swayatt-app/validation" 2>/dev/null || true; then
    STREAM_NAME="validation-$(date +%s)"
    if aws logs create-log-stream --log-group-name "/aws/ec2/swayatt-app/validation" --log-stream-name "$STREAM_NAME" 2>/dev/null; then
        TIMESTAMP=$(date +%s000)
        if aws logs put-log-events --log-group-name "/aws/ec2/swayatt-app/validation" --log-stream-name "$STREAM_NAME" --log-events timestamp=$TIMESTAMP,message="$TEST_MESSAGE" &>/dev/null; then
            echo "   ✅ Successfully published test log"
            echo "   📍 Log Group: /aws/ec2/swayatt-app/validation"
            echo "   📍 Stream: $STREAM_NAME"
        else
            echo "   ❌ Failed to publish test log"
        fi
    else
        echo "   ❌ Failed to create log stream"
    fi
else
    echo "   ❌ Failed to create test log group"
fi

# Check if Docker is running (for container monitoring)
echo "7. Checking Docker Status..."
if systemctl is-active --quiet docker; then
    echo "   ✅ Docker is running"
    DOCKER_VERSION=$(docker --version | cut -d' ' -f3 | cut -d',' -f1)
    echo "   📍 Version: $DOCKER_VERSION"
else
    echo "   ❌ Docker is not running"
    echo "   💡 Start with: sudo systemctl start docker"
fi

# Check for running containers
echo "8. Checking Application Containers..."
CONTAINERS=$(docker ps --filter "name=swayatt" --format "table {{.Names}}\t{{.Status}}" 2>/dev/null | tail -n +2)
if [ -n "$CONTAINERS" ]; then
    echo "   ✅ Swayatt containers found:"
    echo "$CONTAINERS" | sed 's/^/      /'
else
    echo "   ⚠️  No Swayatt containers currently running"
    echo "   💡 Deploy with Jenkins pipeline to start monitoring"
fi

echo ""
echo "📊 CloudWatch Dashboard"
echo "======================="
echo "Access your monitoring dashboard at:"
echo "https://console.aws.amazon.com/cloudwatch/home?region=$(aws configure get region)#dashboards:name=Swayatt-App-Monitoring"

echo ""
echo "📋 Next Steps"
echo "============="
echo "1. If any checks failed, run the setup script: sudo ./setup-cloudwatch.sh"
echo "2. Deploy your application via Jenkins to start log collection"
echo "3. View logs and metrics in the CloudWatch console"
echo "4. Set up alerts for critical metrics if needed"

echo ""
echo "✅ Validation complete!"
