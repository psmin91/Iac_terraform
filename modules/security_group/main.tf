resource "aws_security_group" "this" {
  
  name                  = var.name
  description           = var.description
  vpc_id                = var.vpc_id

  tags	= merge(var.tags, {
		Name	= 	"${var.prj_name}-${var.env}-${var.aws_region_code}-${var.name}"
    })
}

resource "aws_security_group_rule" "ingress_rules" {
  count = length(var.ingress_rules) > 0 ? length(var.ingress_rules) : 0
  

  security_group_id = aws_security_group.this.id
  type              = "ingress"
  description      = var.rules[var.ingress_rules[count.index]][3]
  
  cidr_blocks = var.ingress_cidr_blocks
  from_port = var.rules[var.ingress_rules[count.index]][0]
  to_port   = var.rules[var.ingress_rules[count.index]][1]
  protocol  = var.rules[var.ingress_rules[count.index]][2]
}
resource "aws_security_group_rule" "egress_rules" {
  count = length(var.egress_rules) > 0 ? length(var.egress_rules) : 0

  security_group_id = aws_security_group.this.id
  type              = "egress"
  description      = var.rules[var.egress_rules[count.index]][3]
  
  cidr_blocks      = var.egress_cidr_blocks
  from_port = var.rules[var.egress_rules[count.index]][0]
  to_port   = var.rules[var.egress_rules[count.index]][1]
  protocol  = var.rules[var.egress_rules[count.index]][2]
}
