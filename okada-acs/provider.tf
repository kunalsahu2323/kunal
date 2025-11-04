terraform {
  required_providers {
    scp = {
      source  = "splunk/scp"
      version = ">= 1.0.0"
    }
  }
}

provider "scp" {
  stack  = "itsi-trlei-opsmnl"
  server = "https://itsi-trlei-opsmnl.splunkcloud.com/"
  auth_token = "eyJraWQiOiJzcGx1bmsuc2VjcmV0IiwiYWxnIjoiSFM1MTIiLCJ2ZXIiOiJ2MiIsInR0eXAiOiJzdGF0aWMifQ.eyJpc3MiOiJrdW5hbC5zYWh1QHBydWRlbnRjb25zdWx0aW5nLmNvbSBmcm9tIHNoLWktMDcyYTUwNzJjNjA4ZmNjNzAiLCJzdWIiOiJrdW5hbC5zYWh1QHBydWRlbnRjb25zdWx0aW5nLmNvbSIsImF1ZCI6InVwZGF0ZSBpcCBsaXN0IiwiaWRwIjoiU3BsdW5rIiwianRpIjoiYWNlMTlhNmVjZmM4ZjQwMTgwNDY2ZWJkMGU1YThlMjQ1NjlkOWIxN2EwNWNiNzQ0NTUwYzdjZTYwMTYxZGY2ZCIsImlhdCI6MTc2MDY5MjI1NCwiZXhwIjoxNzYzMjg0MjU0LCJuYnIiOjE3NjA2OTIyNTR9.PzVu6Q2Ej-GcwVO-6pOnOX7za7oHkGooR-lF9e-ppteAOmgPI1sCb4L87rRhfW11f5fmFekY14jkO_0CD7mP9w"
}