resource "grafana_rule_group" "rule_group_0001" {
  org_id           = 1
  name             = "Airflow-Alerts"
  folder_uid       = grafana_folder.test_folder.uid
  interval_seconds = 60

  rule {
    name      = "AirflowSchedulerUnhealthy"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "metrics"
      model          = "{\"editorMode\":\"code\",\"expr\":\"rate(airflow_scheduler_heartbeat{type=\\\"counter\\\"}[1m])\",\"hide\":false,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":true,\"refId\":\"A\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"B\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"B\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0,0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[]},\"reducer\":{\"params\":[],\"type\":\"avg\"},\"type\":\"query\"}],\"datasource\":{\"name\":\"Expression\",\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"$B == 0\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"math\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "6m"
    annotations = {
      description = "The {{ $labels.deployment }} scheduler's heartbeat has dropped below the acceptable rate."
      summary     = "The Airflow scheduler is unhealthy"
    }
    labels = {
      alerttype = "opsverse"
      severity  = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "AirflowDeploymentUnhealthy"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "metrics"
      model          = "{\"editorMode\":\"code\",\"expr\":\"sum by(cluster) (kube_pod_container_status_running{container=~\\\".*(scheduler|scheduler-gc|webserver|worker|statsd|pgbouncer|metrics-exporter|redis|flower|triggerer)\\\"}) - count by(cluster) (kube_pod_container_status_running{container=~\\\".*(scheduler|scheduler-gc|webserver|worker|statsd|pgbouncer|metrics-exporter|redis|flower|triggerer)\\\"})\",\"hide\":false,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":true,\"refId\":\"A\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"B\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"B\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"lt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"B\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "15m"
    annotations = {
      description = "The Airflow deployment is not completely available.\n(Cluster - {{ $labels.cluster }} )."
      summary     = "The Airflow deployment is unhealthy"
    }
    labels = {
      alerttype = "opsverse"
      severity  = "critical"
    }
    is_paused = false
  }
  rule {
    name      = "ContainerMemoryNearTheLimitInDeployment"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "metrics"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(container_memory_working_set_bytes{container=~\\\".*(scheduler|scheduler-gc|webserver|worker|statsd|pgbouncer|metrics-exporter|redis|flower|triggerer)\\\",container_name!~\\\"POD|istio-proxy\\\"} / container_spec_memory_limit_bytes{container=~\\\".*(scheduler|scheduler-gc|webserver|worker|statsd|pgbouncer|metrics-exporter|redis|flower|triggerer)\\\",\\ncontainer_name!~\\\"POD|istio-proxy\\\"}) * 100 \\u003c Inf \",\"hide\":false,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":true,\"refId\":\"A\"}"
    }
    data {
      ref_id = "B"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"B\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"B\",\"type\":\"reduce\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[95],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"B\",\"hide\":false,\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "5m"
    annotations = {
      description = "container {{ $labels.container }} in pod {{ $labels.pod }} in namespace {{ $labels.namespace }} is using {{ $values.B }} % Of available memory."
      summary     = "A container is using more than 95% Of the memory limit"
    }
    labels = {
      alerttype = "opsverse"
      severity  = "warning"
    }
    is_paused = false
  }
}
