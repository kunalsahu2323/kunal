provider "signalfx" {
  auth_token = "AVjHZh1yie1fGeX9F2qHnA"
  # If your organization uses a different realm
  api_url = "https://api.us1.signalfx.com"
  # If your organization uses a custom URL
  # custom_app_url = "https://myorg.signalfx.com"
}

#REPLACE KS WITH YOUR INITIALS TO MAKE THIS UNIQUE IN THE USER INTERFACE
resource "signalfx_time_chart" "tfchart_01" {
    name = "KS_TF_CPU Utilization"
    program_text = <<-EOF
        data("cpu.utilization").publish(label= "cpu")
        EOF
    plot_type = "LineChart"
    show_data_markers = true
}

#REPLACE KS WITH YOUR INITIALS TO MAKE THIS UNIQUE IN THE USER INTERFACE
resource "signalfx_time_chart" "tfchart_02" {
    name = "KS_TF_Memory Utilization"
    program_text = <<-EOF
        data("memory.utilization").publish(label= "memory")
        EOF
    plot_type = "AreaChart"
    show_data_markers = true
}

#REPLACE KS WITH YOUR INITIALS TO MAKE THIS UNIQUE IN THE USER INTERFACE
resource "signalfx_time_chart" "tfchart_03" {
    name = "KS_TF_Latency"
    program_text = <<-EOF
        data("dem_latency").publish(label= "latency")
        EOF
    plot_type = "LineChart"
    show_data_markers = true
}

#REPLACE KS WITH YOUR INITIALS TO MAKE THIS UNIQUE IN THE USER INTERFACE
resource "signalfx_time_chart" "tfchart_04" {
    name = "KS_TF_Number of API Calls"
    program_text = <<-EOF
        data("dem_numcalls").publish(label= "API Calls")
        EOF
    plot_type = "ColumnChart"
    show_data_markers = true
}

resource "signalfx_time_chart" "tfchart_05" {
    name = "KS_TF_Latency vs Transactions"
    description = "p99 Latency vs Total number of transactions"
    program_text = <<-EOF
        data("dem_latency").percentile(99).publish(label= "p99-latency")
        data("dem_numcalls",rollup="sum").sum().publish(label= "Sum-transactions")
        EOF
    plot_type = "LineChart"
    show_data_markers = true
    viz_options {
    label     = "Sum-transactions"
    axis      = "right"
    color     = "orange"
    plot_type = "ColumnChart"
  }
}

resource "signalfx_single_value_chart" "tfchart_06" {
    name = "KS_TF_p99 Memory"
    description = "99th percentile of Memory utilization"
    program_text = <<-EOF
        data("memory.utilization").percentile(99).publish(label= "p99-memory")
        EOF
    color_by = "Scale"
    color_scale {
        gte="85.0"
        lte="100.0"
        color = "red"
    }
    color_scale {
        lt="85.0"
        gte="0.0"
        color = "green"
    }
    secondary_visualization = "Radial"
}

resource "signalfx_list_chart" "tfchart_07" {
  name = "KS_TF_%change in API Calls"

  program_text = <<-EOF
    A=data("dem_numcalls",rollup="sum").sum(by="dem_service")
    B=data("dem_numcalls",rollup="sum").sum(by="dem_service").timeshift('1d')
    C=((A - B)*100/B).publish(label= "%change")
    EOF

  description = " % change in total number of API calls in the last 24hours"
  color_by = "Scale"
color_scale {
    gte   = 0.0
    color = "green"
  }
color_scale {
    lt    = 0.0
    color = "red"
  }

  legend_options_fields {
    property = "sf_metric"
    enabled  = false
  }
  legend_options_fields {
    property = "dem_service"
    enabled  = true
  }
  legend_options_fields {
    property = "sf_originatingMetric"
    enabled  = false
  }

  viz_options {
    label        = "%change"
    value_suffix = "%"
  }
}

resource "signalfx_heatmap_chart" "tfchart_08" {
  name = "KS_TF_p99Latency"

  program_text = <<-EOF
        data("dem_latency").percentile(99,by=['dem_service']).publish(label= "latency")
        EOF

  description = "99th percentile of latency by each service"
  disable_sampling = true

  color_scale {
    lt    = 30.0
    color = "green"
  }
  color_scale {
    gte   = 30.0
    lt    = 100.0
    color = "yellow"
  }
  color_scale {
    gte   = 100.0
    color = "red"
  }
}

#LAB 3c - ADDTIONAL CHARTS TO ADD TO THE OVERVIEW DASHBOARD 
#COPY THESE CHARTS TO YOUR FILE - main.tf
#REPLACE KS WITH YOUR INITIALS TO MAKE THIS UNIQUE IN THE USER INTERFACE    
resource "signalfx_list_chart" "tfchart_09" {
    name = "KS_TF_p99 Latency By Service"
    program_text = <<-EOF
        data("dem_latency").percentile(99,by="dem_service").publish(label= "latency_by_service")
        EOF
    legend_options_fields {
    property = "dem_service"
    enabled  = true
    }
    legend_options_fields {
    property = "sf_metric"
    enabled  = false
    }
    legend_options_fields {
    property = "sf_originatingMetric"
    enabled  = false
    } 
}

#REPLACE KS WITH YOUR INITIALS TO MAKE THIS UNIQUE IN THE USER INTERFACE
resource "signalfx_list_chart" "tfchart_10" {
    name = "KS_TF_Number of API Calls by service"
    program_text = <<-EOF
        data("dem_numcalls", rollup="sum").sum(by="dem_service").publish(label= "APICalls_by_service")
        EOF
    legend_options_fields {
    property = "dem_service"
    enabled  = true
    }
    legend_options_fields {
    property = "sf_metric"
    enabled  = false
    }
    legend_options_fields {
    property = "sf_originatingMetric"
    enabled  = false
    } 
}

resource "signalfx_data_link" "dlink0" {
  property_name  = "dem_service"

  context_dashboard_id = signalfx_dashboard.db02.id

  target_signalfx_dashboard {
    is_default         = true
    name               = "KS_overview"
    dashboard_group_id = signalfx_dashboard_group.dbg0.id
    dashboard_id       = signalfx_dashboard.db01.id
  }
}

