resource "signalfx_dashboard_group" "dbg0" {
  name        = "KS_TF_Overview Dashboard Group"
  description = "KS_TF_Overview Dashboard Group"
  permissions {
      principal_id    = "Ggz8tIwA4DI"
      principal_type  = "ORG"
      actions         = ["READ"]
    }
}

resource "signalfx_dashboard" "db01" {
  name            = "KS_TF_Overview Dashboard"
  description = "This is an overview dashboard for overall health"
  dashboard_group = signalfx_dashboard_group.dbg0.id

  permissions {
    acl {
      principal_id    = "Gg0Bod5A0AA"
      principal_type  = "USER"
      actions         = ["READ","WRITE"]
    }
  }

  chart {
    chart_id = signalfx_time_chart.tfchart_01.id
    width    = 6
    height   = 1
    row = 0
    column = 0
  }
  chart {
    chart_id = signalfx_time_chart.tfchart_02.id
    width    = 6
    height   = 1
    row = 0
    column = 6
  }
  chart {
    chart_id = signalfx_single_value_chart.tfchart_06.id
    width    = 3
    height   = 1
    row = 1
    column = 0
  }
  #LAB 3C :ADDING ADDITIONAL CHARTS TO OVERVIEW DASHBOARD
#ADD THIS CODE TO YOUR main.tf TO THE OVERVIEW DASHBOARD RESOURCE
  chart {
    chart_id = signalfx_list_chart.tfchart_09.id
    width    = 3
    height   = 1
    column = 0
    row=2
  }
  chart {
    chart_id = signalfx_list_chart.tfchart_10.id
    column = 0
    width    = 3
    height   = 1
    row=3
  }
}

resource "signalfx_dashboard" "db02" {
  name            = "KS_TF_Business Metrics Dashboard"
  description = "This is an overview dashboard for business health"
  dashboard_group = signalfx_dashboard_group.dbg0.id

  time_range = "-12h"

  filter {
    property = "dem_service"
    values   = ["login", "myaccount","shoppingcart","checkout"]
  }

  variable {
    property = "datacenter"
    alias    = "DataCenter"
    apply_if_exist = true
  }
  
  grid{
      chart_ids = [
          signalfx_time_chart.tfchart_03.id,
          signalfx_time_chart.tfchart_04.id,
          signalfx_time_chart.tfchart_05.id,
          signalfx_list_chart.tfchart_07.id
      ]
      width = 3
      height = 1
  }
}

resource "signalfx_dashboard" "db_import" {
    dashboard_group   = "GjmGCsVAwAA"
    name              = "KS_Workspace"

    chart {
        chart_id = "GjmJn5SA0AM"
        column   = 0
        height   = 1
        row      = 0
        width    = 6
    }

    permissions {
        parent = "GjmGCsVAwAA"
    }
}

resource "signalfx_time_chart" "chart_import" {
    axes_include_zero         = false
    axes_precision            = 0
    color_by                  = "Dimension"
    description               = "KS_p99 CPU by Datacenter_tf"
    disable_sampling          = false
    max_delay                 = 0
    minimum_resolution        = 0
    name                      = "KS_p99 CPU by Datacenter_tf"
    on_chart_legend_dimension = null
    plot_type                 = "LineChart"
    program_text              = "A = data('cpu.utilization').percentile(pct=99, by=['datacenter']).publish(label='A')"
    show_data_markers         = false
    show_event_lines          = false
    stacked                   = false
    time_range                = 900
    timezone                  = null
    unit_prefix               = "Metric"

    histogram_options {
        color_theme = "red"
    }

    viz_options {
        axis         = "left"
        color        = null
        display_name = "cpu.utilization"
        label        = "A"
        plot_type    = null
        value_prefix = null
        value_suffix = null
        value_unit   = null
    }
}