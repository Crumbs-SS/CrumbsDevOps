#!/bin/bash
yum install httpd -y
service httpd start
echo "Terraform VPC Instance" >> /var/www/html/index.html