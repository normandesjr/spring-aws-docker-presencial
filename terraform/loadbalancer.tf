resource "aws_lb" "alb" {
  name            = "hibicode-alb"
  security_groups = ["${aws_security_group.allow_load_balancer.id}"]
  subnets         = ["${flatten(chunklist(aws_subnet.public_subnet.*.id, 1))}"]

  enable_deletion_protection = false

  tags {
    Name = "hibicode_alb"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name     = "instances-tg"
  port     = "8080"
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 3
    timeout             = 10
    path                = "/actuator/health"
    interval            = 120
    matcher             = 200
  }

  tags {
    Name = "hibicode_alb_tg"
  }
}

resource "aws_lb_target_group_attachment" "alb_group_attachment" {
  # count            = "${length(aws_instance.instances.*.id)}"
  count            = "3"
  target_group_arn = "${aws_lb_target_group.alb_tg.arn}"
  target_id        = "${element(aws_instance.instances.*.id, count.index)}"
  port             = "8080"
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.alb_tg.arn}"
    type             = "forward"
  }
}

output "loadbalancer" {
  value = "${aws_lb.alb.dns_name}"
}
