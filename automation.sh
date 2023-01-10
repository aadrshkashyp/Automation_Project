#!/bin/bash

# define variables
myname="<aadarsh>"
s3_bucket="<upgrad-aadarsh>"

# update package details and package list
sudo apt update -y

# check if apache2 package is installed
if dpkg -s apache2 2>/dev/null | grep -q "Status: install ok installed"; then
    echo "Apache2 package is already installed"
else
    # install apache2 package if not already installed
    echo "Installing Apache2 package..."
    sudo apt install apache2 -y
    if [ $? -eq 0 ]; then
        echo "Apache2 package installed successfully"
    else
        echo "Error installing Apache2 package"
        exit 1
    fi
fi

# check if apache2 service is running
if systemctl is-active --quiet apache2; then
    echo "Apache2 service is running"
else
    # start apache2 service if not already running
    echo "Starting Apache2 service..."
    sudo systemctl start apache2
    if [ $? -eq 0 ]; then
        echo "Apache2 service started successfully"
    else
        echo "Error starting Apache2 service"
        exit 1
    fi
fi

# check if apache2 service is enabled
if systemctl is-enabled --quiet apache2; then
    echo "Apache2 service is enabled"
else
    # enable apache2 service if not already enabled
    echo "Enabling Apache2 service..."
    sudo systemctl enable apache2
    if [ $? -eq 0 ]; then
        echo "Apache2 service enabled successfully"
    else
        echo "Error enabling Apache2 service"
        exit 1
    fi
fi

# check if /var/log/apache2/ directory exists
if [ ! -d "/var/log/apache2/" ]; then
    echo "/var/log/apache2/ directory not found"
    exit 1
fi

# create timestamp variable
timestamp=$(date '+%d%m%Y-%H%M%S')

# create tar archive of apache2 access and error logs in /var/log/apache2/ directory
# only include .log files, not other file types like .zip or .tar
echo "Creating tar archive of Apache2 logs..."
sudo tar -cvzf /tmp/${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/*.log
if [ $? -eq 0 ]; then
    echo "Tar archive created successfully: /tmp/${myname}-httpd-logs-${timestamp}.tar"
else
    echo "Error creating tar archive"
    exit 1
fi

# copy tar archive to s3 bucket
echo "Copying tar archive to S3 bucket..."
aws s3 cp /tmp/${myname}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar
if [ $? -eq 0 ]; then
   echo "Tar archive copied to S3 bucket successfully: s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar"
else
    echo "Error copying tar archive to S3 bucket"
    exit 1
fi

# check if AWS CLI is installed
if command -v aws > /dev/null; then
    echo "AWS CLI is installed"
else
    # install AWS CLI if not already installed
    echo "Installing AWS CLI..."
    sudo apt install awscli -y
    if [ $? -eq 0 ]; then
        echo "AWS CLI installed successfully"
    else
        echo "Error installing AWS CLI"
        exit 1
    fi
fi
