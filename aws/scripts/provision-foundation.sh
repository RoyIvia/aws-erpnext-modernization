#!/usr/bin/env bash

set -euo pipefail

AWS_REGION="${AWS_REGION:-af-south-1}"
PROJECT_NAME="${PROJECT_NAME:-erpnext-modernization}"

VPC_CIDR="10.0.0.0/16"
PUBLIC_SUBNET_CIDR="10.0.1.0/24"
PRIVATE_SUBNET_CIDR="10.0.2.0/24"

echo "Deploying ${PROJECT_NAME} network foundation in ${AWS_REGION}"

VPC_ID=$(aws ec2 create-vpc \
  --region "$AWS_REGION" \
  --cidr-block "$VPC_CIDR" \
  --tag-specifications \
  "ResourceType=vpc,Tags=[{Key=Name,Value=${PROJECT_NAME}-vpc},{Key=Project,Value=${PROJECT_NAME}}]" \
  --query 'Vpc.VpcId' \
  --output text)

aws ec2 modify-vpc-attribute \
  --region "$AWS_REGION" \
  --vpc-id "$VPC_ID" \
  --enable-dns-support '{"Value":true}'

aws ec2 modify-vpc-attribute \
  --region "$AWS_REGION" \
  --vpc-id "$VPC_ID" \
  --enable-dns-hostnames '{"Value":true}'

AZS=($(aws ec2 describe-availability-zones \
  --region "$AWS_REGION" \
  --filters Name=state,Values=available \
  --query 'AvailabilityZones[].ZoneName' \
  --output text))

if [ "${#AZS[@]}" -lt 2 ]; then
  echo "At least two Availability Zones are required."
  exit 1
fi

PUBLIC_SUBNET_ID=$(aws ec2 create-subnet \
  --region "$AWS_REGION" \
  --vpc-id "$VPC_ID" \
  --cidr-block "$PUBLIC_SUBNET_CIDR" \
  --availability-zone "${AZS[0]}" \
  --tag-specifications \
  "ResourceType=subnet,Tags=[{Key=Name,Value=${PROJECT_NAME}-public-subnet}]" \
  --query 'Subnet.SubnetId' \
  --output text)

PRIVATE_SUBNET_ID=$(aws ec2 create-subnet \
  --region "$AWS_REGION" \
  --vpc-id "$VPC_ID" \
  --cidr-block "$PRIVATE_SUBNET_CIDR" \
  --availability-zone "${AZS[1]}" \
  --tag-specifications \
  "ResourceType=subnet,Tags=[{Key=Name,Value=${PROJECT_NAME}-private-subnet}]" \
  --query 'Subnet.SubnetId' \
  --output text)

IGW_ID=$(aws ec2 create-internet-gateway \
  --region "$AWS_REGION" \
  --tag-specifications \
  "ResourceType=internet-gateway,Tags=[{Key=Name,Value=${PROJECT_NAME}-igw}]" \
  --query 'InternetGateway.InternetGatewayId' \
  --output text)

aws ec2 attach-internet-gateway \
  --region "$AWS_REGION" \
  --internet-gateway-id "$IGW_ID" \
  --vpc-id "$VPC_ID"

PUBLIC_RT_ID=$(aws ec2 create-route-table \
  --region "$AWS_REGION" \
  --vpc-id "$VPC_ID" \
  --tag-specifications \
  "ResourceType=route-table,Tags=[{Key=Name,Value=${PROJECT_NAME}-public-rt}]" \
  --query 'RouteTable.RouteTableId' \
  --output text)

aws ec2 create-route \
  --region "$AWS_REGION" \
  --route-table-id "$PUBLIC_RT_ID" \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id "$IGW_ID"

aws ec2 associate-route-table \
  --region "$AWS_REGION" \
  --route-table-id "$PUBLIC_RT_ID" \
  --subnet-id "$PUBLIC_SUBNET_ID" >/dev/null

aws ec2 modify-subnet-attribute \
  --region "$AWS_REGION" \
  --subnet-id "$PUBLIC_SUBNET_ID" \
  --map-public-ip-on-launch

echo
echo "Network foundation created:"
echo "VPC:            $VPC_ID"
echo "Public subnet:  $PUBLIC_SUBNET_ID"
echo "Private subnet: $PRIVATE_SUBNET_ID"
echo "Internet GW:    $IGW_ID"
echo "Public RT:      $PUBLIC_RT_ID"
