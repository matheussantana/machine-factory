#resource "random_uuid" "test" { }
variable host {
	type= string
}

variable tags {}


#data "null_resource" "api_gw_url" {
#    inputs = {
#      #main_api_gw = "${random_uuid.test.result}${var.host}"
#      main_api_gw = "xxx"
#    }
#}

variable "namespace" {
  type = string
}

variable ip_list {
  type = list
}

variable ttl {
  type = string
  default = "300"
}

#resource "aws_route53_zone" "main" {
#  name =  "${random_uuid.test.result}.${var.host}"
  #data.null_resource.api_gw_url

#  tags = var.tags
#}

variable type {
  type = string
  default = "A"
}

variable id {
  type = string
  default = "00000000-0000-0000-0000-000000000000"
}

resource "aws_route53_record" "www" {
  zone_id = "Z1M9N04L5GVKSX"
  #name =  "${random_uuid.test.result}"
  name = "${var.id}"
  type    = var.type
  ttl     = var.ttl
  records = var.ip_list
}

output dns {
  value = aws_route53_record.www
}