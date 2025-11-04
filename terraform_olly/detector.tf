resource "signalfx_detector" "det_01" {

  name        = "KS_TF_p99 Memory by Datacenter"
  description = "p99 Memory Utilization is high in a datacenter"

  program_text = <<-EOF
    A = data('memory.utilization').percentile(99, by=['datacenter']).publish()
    detect(when(A > 90,'5m'), off=when(A < 50,'5m')).publish('p99 of memory by datacenter')
    EOF

  rule {
    description  = "p99 of memory > 90"
    severity     = "Critical"
    detect_label = "p99 of memory by datacenter"
  }
}

resource "signalfx_detector" "det_02" {

  name        = "KS_TF_Memory usage of a container"
  description = "High memory usage of a container"

  program_text = <<-EOF
    A = data('memory.usage.limit').publish()
    B = data('memory.usage.total').publish()
    C = (100*(A-B)/A).publish()
    detect(when(C> 70,'5m')).publish('container mem-critical')
    detect(when(50 < C and C <= 70,'10m')).publish('container mem-major')
    EOF

  rule {
    description  = "mem usage > 70"
    severity     = "Critical"
    detect_label = "container mem-critical"
  }
  rule {
    description  = "50 < mem usage < 70"
    severity     = "Major"
    detect_label = "container mem-major"
  }
}

resource "signalfx_alert_muting_rule" "muting_01" {
  description = "KS_TF_Testing muting rules"

  start_time = 1739467400
  stop_time  = 1739490000

  detectors = [signalfx_detector.det_01.id]

  filter {
    property       = "service_type"
    property_value = "production"
  }
}