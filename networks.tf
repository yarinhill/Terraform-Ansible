#Create VPC for jenkins-master
resource "aws_vpc" "vpc_master" {
  provider             = aws.region-master
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "master-vpc-jenkins"
  }
}

#Create VPC for jenkins-worker
resource "aws_vpc" "vpc_master_worker" {
  provider             = aws.region-worker
  cidr_block           = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "worker-vpc-jenkins"
  }
}

#Create IGW for jenkins-master
resource "aws_internet_gateway" "igw" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc_master.id
}

#Create IGW for jenkins-worker
resource "aws_internet_gateway" "igw-worker" {
  provider = aws.region-worker
  vpc_id   = aws_vpc.vpc_master_worker.id
}

#Get all available AZ's in VPC for master region
data "aws_availability_zones" "azs" {
  provider = aws.region-master
  state    = "available"
}


#Create subnet # 1 for jenkins-master
resource "aws_subnet" "subnet_1" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc_master.id
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "subnet_1_jenkins_master"
  }
}


#Create subnet #2 for jenkins-master
resource "aws_subnet" "subnet_2" {
  provider          = aws.region-master
  vpc_id            = aws_vpc.vpc_master.id
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = "subnet_2_jenkins_master"
  }
}


#Create subnet for jenkins-worker
resource "aws_subnet" "subnet_1_worker" {
  provider   = aws.region-worker
  vpc_id     = aws_vpc.vpc_master_worker.id
  cidr_block = "192.168.1.0/24"
  tags = {
    Name = "subnet_1_jenkins_worker"
  }
}



#Initiate Peering connection request from jenkins-master
resource "aws_vpc_peering_connection" "master-worker" {
  provider    = aws.region-master
  peer_vpc_id = aws_vpc.vpc_master_worker.id
  vpc_id      = aws_vpc.vpc_master.id
  peer_region = var.region-worker
}

#Accept VPC peering request in jenkins-worker from jenkins-master
resource "aws_vpc_peering_connection_accepter" "accept_peering" {
  provider                  = aws.region-worker
  vpc_peering_connection_id = aws_vpc_peering_connection.master-worker.id
  auto_accept               = true
}


#Create route table for jenkins-master
resource "aws_route_table" "internet_route" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc_master.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  route {
    cidr_block                = "192.168.1.0/24"
    vpc_peering_connection_id = aws_vpc_peering_connection.master-worker.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "Master-Region-RT"
  }
}

#Overwrite default route table of VPC(Master) with our route table entries
resource "aws_main_route_table_association" "set-master-default-rt-assoc" {
  provider       = aws.region-master
  vpc_id         = aws_vpc.vpc_master.id
  route_table_id = aws_route_table.internet_route.id
}

#Create route table for jenkins-worker
resource "aws_route_table" "internet_route_worker" {
  provider = aws.region-worker
  vpc_id   = aws_vpc.vpc_master_worker.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-worker.id
  }
  route {
    cidr_block                = "10.0.1.0/24"
    vpc_peering_connection_id = aws_vpc_peering_connection.master-worker.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "Worker-Region-RT"
  }
}

#Overwrite default route table of VPC(Worker) with our route table entries
resource "aws_main_route_table_association" "set-worker-default-rt-assoc" {
  provider       = aws.region-worker
  vpc_id         = aws_vpc.vpc_master_worker.id
  route_table_id = aws_route_table.internet_route_worker.id
}

