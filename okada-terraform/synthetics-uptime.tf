resource "synthetics_create_http_check_v2" "http_ptc" {
  test {
    active = true 
    frequency = 1
    location_ids = ["aws-us-east-1","aws-us-east-2"]
    name = "Terraform1 - Http uptime ptc"
    type = "http"
    url = "https://prudentconsulting.com:444/careers/"
    scheduling_strategy = "round_robin"
    custom_properties {
            key = "env"
            value = "test"
        }
    request_method = "GET"
    verify_certificates = true
  }    
}