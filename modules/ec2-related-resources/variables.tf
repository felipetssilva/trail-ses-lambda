variable "ec2-name" {
    type = string
    default = "aws_instance.trail-followed-ec2.id"
}

variable "main_vpc" {
    type = string
    default = "aws_vpc.main.id"
}

variable "public_subnet" {
    type = string
    default = "aws_subnet.public.id"
}

variable "igw" {
    type = string
    default = "aws_internet_gateway.igw.id"
}

variable "main-route-table" {    
    type = string
    default = "aws_route_table.main.id"
}

variable "ec2-sg" {
    type = string
    default = "aws_security_group.ec2_sg.id"
}   

variable "main-route-table-association" {    
    type = string
    default = "aws_route_table_association.public.id"
}