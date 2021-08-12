variable subnet_id_list {
        type = list(string)
        #default = ["subnet-45aeba22", "subnet-66ca0368"]
}

variable os_image {
        type = string
        #default = "ami-0f4e7da4bb29aa6f5"
}

variable firewall_id_list {
        type = list(string)
        #default = ["sg-0444a67cbc15a039e"]
}

# Network
variable param_network_id { default = "vpc-038aaa79" }

variable "namespace" {
  type = string
}



resource "aws_lb" "front_end" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.firewall_id_list
  subnets            = var.subnet_id_list

  enable_deletion_protection = false

  #access_logs {
  #  bucket  = "ebebe150-2617-45f2-8a0a-6c7ad412c17e-dev"#"${module.buckets3-backend.aws_s3_bucket.bucket}"
  #  prefix  = "test-lb"
  #  enabled = true
  #}

  tags = {
    Environment = "production"
  }
}


resource "aws_lb_target_group" "front_end" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.param_network_id
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.front_end.arn}"
  port              = "80"
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.front_end.arn}"
  }
}


resource "aws_lb_target_group" "front_end-ssl" {
  name     = "tf-lb-tg-ssl"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = var.param_network_id
}


resource "aws_lb_listener" "front_end-ssl" {
  load_balancer_arn = "${aws_lb.front_end.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${aws_acm_certificate.cert.arn}"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.front_end-ssl.arn}"
  }
}

module "autoscale_group" {
  source = "git::https://github.com/cloudposse/terraform-aws-ec2-autoscale-group.git?ref=master"

  namespace = var.namespace
  stage     = "dev"
  name      = "test"

  image_id                    = var.os_image
  instance_type               = "t2.small"
  security_group_ids          = var.firewall_id_list
  subnet_ids                  = var.subnet_id_list
  health_check_type           = "EC2"
  min_size                    = 2
  max_size                    = 5
  wait_for_capacity_timeout   = "5m"
  associate_public_ip_address = true
  #user_data_base64            = "${base64encode(local.userdata)}"

  tags = {
    Tier              = "1"
    KubernetesCluster = "us-west-2.testing.cloudposse.co"
  }

  # Auto-scaling policies and CloudWatch metric alarms
  autoscaling_policies_enabled           = "true"
  cpu_utilization_high_threshold_percent = "40"
  cpu_utilization_low_threshold_percent  = "20"
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = "${module.autoscale_group.autoscaling_group_name}"
  #elb                    = "${aws_lb.front_end.id}"
  alb_target_group_arn  = "${aws_lb_target_group.front_end.arn}"
  #depends_on = [module.autoscale_group]

}


resource "aws_autoscaling_attachment" "asg_attachment-ssl" {
  autoscaling_group_name = "${module.autoscale_group.autoscaling_group_name}"
  #elb                    = "${aws_lb.front_end.id}"
  alb_target_group_arn  = "${aws_lb_target_group.front_end-ssl.arn}"
  #depends_on = [module.autoscale_group]
}


resource "aws_iam_server_certificate" "ssl-cert" {
  name             = var.namespace
  certificate_body = "${file("./files/ssl-keys/cert.pem")}"
  private_key      = "${file("./files/ssl-keys/privkey.pem")}"
}

resource "aws_acm_certificate" "cert" {
  #name             = var.namespace
  certificate_body = "${file("./files/ssl-keys/cert.pem")}"
  private_key      = "${file("./files/ssl-keys/privkey.pem")}"
  certificate_chain = "${file("./files/ssl-keys/fullchain.pem")}"
}



output "aws_acm_certificate" {
  value = aws_acm_certificate.cert
}