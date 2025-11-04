resource "scp_ip_allowlists" "search-api" {
  feature = "s2s"
  subnets = ["44.230.152.35/24"] 
}