#create launch template

resource "aws_launch_template" "webserver_launch_template" {
  name = var.launch_template_name
  image_id = var.EC2_image_id
  instance_type = var.EC2_instance
  key_name = var.EC2_key_pair_name
  description = "launch template for asg"
  monitoring {
    enabled = true
  }
  vpc_security_group_ids = [ aws_security_group.webserver_sg.id ]
}

#create auto scailing group

resource "aws_autoscaling_group" "ASG" {
  vpc_zone_identifier = [aws_subnet.private_app_subnet_az1.id, aws_subnet.private_app_subnet_az2.id]
   desired_capacity = 2
   max_size = 4
   min_size = 1
   name = "dev-asg"
   health_check_type = "ELB"

   launch_template {
     name = aws_launch_template.webserver_launch_template.name
     version = "$latest"

   }

   tag {
     key = "Name"
     value = "asg-webserver"
     propagate_at_launch = true
   }

   lifecycle {
     ignore_changes = [ target_group_arn ]
   }

}

#attach auto scailing group to the alb target group
#terraform autoscailing attachment

resource "aws_autoscaling_attachment" "asg-attachment" {
    autoscaling_group_name = aws_autoscaling_group.ASG
    lb_target_group_arn = aws_lb_target_group.alb_tg.arn
  
}

#terraform aws autoscailing group notification

resource "aws_autoscaling_notification" "webserver_asg_notification" {
    group_names = [aws_autoscaling_group.ASG.name]

    notifications = [
        "autoscailing:EC2_INSTANCE_LAUNCH",
        "autoscailing:EC2_INSTANCE_TERMINATION",
        "autoscailing:EC2_LAUNCH_ERROR",
        "autoscailing:EC2_INSTANCE_TERMINATION_ERROR",
    ]

    topic_arn = aws_sns_topic.updates.arn
  
}