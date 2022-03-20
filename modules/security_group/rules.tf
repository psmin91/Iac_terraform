#https://github.com/terraform-aws-modules/terraform-aws-security-group/blob/master/rules.tf
variable "rules" {
  description = "Map of known security group rules (define as 'name' = ['from port', 'to port', 'protocol', 'description'])"
  type        = map(list(any))

  # Protocols (tcp, udp, icmp, all - are allowed keywords) or numbers (from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml):
  # All = -1, IPV4-ICMP = 1, TCP = 6, UDP = 17, IPV6-ICMP = 58
  default = {
    # HTTP
    http-80-tcp   = [80, 80, "tcp", "HTTP"]
    http-8080-tcp = [8080, 8080, "tcp", "HTTP"]
    # HTTPS
    https-443-tcp  = [443, 443, "tcp", "HTTPS"]
    https-8443-tcp = [8443, 8443, "tcp", "HTTPS"]
    # SSH
    ssh-tcp = [22, 22, "tcp", "SSH"]
    # Open all ports & protocols
    all-all       = [-1, -1, "-1", "All protocols"]
    all-tcp       = [0, 65535, "tcp", "All TCP ports"]
    all-udp       = [0, 65535, "udp", "All UDP ports"]
    all-icmp      = [-1, -1, "icmp", "All IPV4 ICMP"]
    all-ipv6-icmp = [-1, -1, 58, "All IPV6 ICMP"]
    # This is a fallback rule to pass to lookup() as default. It does not open anything, because it should never be used.
    _ = ["", "", ""]
  }
}