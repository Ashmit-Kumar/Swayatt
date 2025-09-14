#!/bin/bash

# CloudWatch Agent Installation and Configuration Script
# This script installs and configures AWS CloudWatch agent for monitoring and logging

set -e

echo "=== CloudWatch Agent Setup Script ==="
echo "Installing and configuring AWS CloudWatch Agent..."

# Check if running on AWS EC2 instance
if ! command -v aws &> /dev/null; then
    echo "Installing AWS CLI..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip
    sudo ./aws/install
    rm -rf aws awscliv2.zip
fi

# Download and install CloudWatch agent
echo "Downloading CloudWatch Agent..."
wget -q https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm

echo "Installing CloudWatch Agent..."
sudo rpm -U ./amazon-cloudwatch-agent.rpm

# Create necessary directories
sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/etc/
sudo mkdir -p /var/log/jenkins/
sudo mkdir -p /var/log/docker/containers/

# Copy configuration file
echo "Configuring CloudWatch Agent..."
sudo cp cloudwatch-config.json /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

# Configure CloudWatch agent
echo "Starting CloudWatch Agent configuration..."
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config \
    -m ec2 \
    -s \
    -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

# Enable CloudWatch agent to start on boot
sudo systemctl enable amazon-cloudwatch-agent

echo "=== CloudWatch Agent Setup Complete ==="
echo ""
echo "Log Groups Created:"
echo "- /aws/ec2/swayatt-app/docker     (Docker container logs)"
echo "- /aws/ec2/swayatt-app/jenkins    (Jenkins application logs)"
echo "- /aws/ec2/swayatt-app/pipeline   (CI/CD pipeline logs)"
echo ""
echo "Metrics Namespace: Swayatt/Application"
echo ""
echo "You can view logs and metrics in AWS CloudWatch Console:"
echo "https://console.aws.amazon.com/cloudwatch/"

# Cleanup
rm -f amazon-cloudwatch-agent.rpm

echo "CloudWatch monitoring is now active!"
