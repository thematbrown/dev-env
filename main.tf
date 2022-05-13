resource "aws_vpc" "dev_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev_vpc"
  }
}

resource "aws_subnet" "dev_public_subnet" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a"

  tags = {
    Name = "dev_public"
  }
}

resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "dev_igw"
  }
}

resource "aws_route_table" "dev_public_rt" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "dev_public_rt"
  }
}

resource "aws_route" "dev_route" {
  route_table_id         = aws_route_table.dev_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dev_igw.id
}


resource "aws_route_table_association" "dev_public_assoc" {
  subnet_id      = aws_subnet.dev_public_subnet.id
  route_table_id = aws_route_table.dev_public_rt.id
}

resource "aws_security_group" "dev_sg" {
  name        = "dev_sg"
  description = "Dev security group"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"] # Place your IP address here
    from_port   = 0
    to_port     = 0
    protocol    = -1

  }

  egress {
    cidr_blocks = ["0.0.0.0/0"] # Place your IP address here
    from_port   = 0
    to_port     = 0
    protocol    = -1

  }
}

resource "aws_key_pair" "dev_env_key" {
  key_name   = "dev_env_key"
  public_key = file("~/.ssh/mykeys/dev_env.pub")
}

resource "aws_instance" "name" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.instance_ami.id
  key_name               = aws_key_pair.dev_env_key.id
  vpc_security_group_ids = [aws_security_group.dev_sg.id]
  subnet_id              = aws_subnet.dev_public_subnet.id

  tags = {
    Name = "dev-node"
  }

  user_data = file("userdata.tpl")
}
