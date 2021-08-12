resource "aws_iam_role" "access_role" {
  name = "${var.namespace}_${var.role_name}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
     {
	"Effect": "${var.access_level}",
	"Principal": {
	  "Service": "${var.target_service}"
	},
	"Action": "sts:AssumeRole"
     }
   ]
}
EOF
}


resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.namespace}_${var.role_name}_instance_profile"
  role = "${aws_iam_role.access_role.name}"
}




