#create  application load balancer which will be internet facing

resource "aws_alb" "alb" {
    name = "dev-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb_sg.id]


    subnet_mapping {
      subnet_id = aws_subnet.public_subnet_az1.id
    }

    subnet_mapping {
      subnet_id = aws_subent.public_subnet_az2.id
    }

    enable_deletion_protection = false

    tags = {
      Name = "dev-alb"
    }
}

#create target group
resource "aws_lb_target_group" "alb_tg" {
  name     = "dev-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    healthy_threshold = 5
    interval = 30
    matcher = "200, 301, 302"
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"
    timeout = 5
    unhealthy_threshold = 2
  }
}
#Create a listener on port 80 with redirect action

resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "redirect"

    redirect {
      host = "#{host}"
      path = "/#{path}"
      port = 443
      protocol = "HTTPS"
      status_code = "HTTP_301"

    }
  }
}

#Create a listener on port 443 with forward action

resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.ssl_certificate_arn

  default_action {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    type             = "forward"
  }
}