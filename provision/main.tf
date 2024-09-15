resource "lxd_volume" "volume" {
  for_each = {
    vlogs_var     = "vlogs_var"
    vlogs_logs    = "logs_volume_vlogs"
    loki_var      = "loki_var"
    loki_logs     = "logs_volume_loki"
  }

  name    = each.value
  pool    = local.pool
  config  = {
    size = local.volume_size
  }
  project = local.project
}

# Define reusable instance resource with attachable volumes
resource "lxd_instance" "loki-bench" {
  name    = "loki-bench"
  image   = "ubuntu:22.04"
  type    = "virtual-machine"
  project = local.project

  # Attach volumes using devices
  device {
    name = "loki_var"
    type = "disk"
    properties = {
      path   = "/var/logs"
      source = lxd_volume.volume["loki_var"].name
      pool   = local.pool
    }
  }

  device {
    name = "logs"
    type = "disk"
    properties = {
      path   = "/mnt/logs"
      source = lxd_volume.volume["loki_logs"].name
      pool   = local.pool
    }
  }

  # Limits
  limits = {
    cpu    = local.cpu_limit
    memory = local.memory_limit
  }
}

resource "lxd_instance" "grafana-bench" {
  name    = "grafana-bench"
  image   = "ubuntu:22.04"
  project = local.project

  # Limits
  limits = {
    cpu    = local.cpu_limit
    memory = local.memory_limit
  }
}

resource "lxd_instance" "vlogs-bench" {
  name    = "vlogs-bench"
  image   = "ubuntu:22.04"
  type    = "virtual-machine"
  project = local.project

  # Attach volumes using devices
  device {
    name = "vlogs_var"
    type = "disk"
    properties = {
      path   = "/var/logs"
      source = lxd_volume.volume["vlogs_var"].name
      pool   = local.pool
    }
  }

  device {
    name = "logs"
    type = "disk"
    properties = {
      path   = "/mnt/logs"
      source = lxd_volume.volume["vlogs_logs"].name
      pool   = local.pool
    }
  }

  # Limits
  limits = {
    cpu    = local.cpu_limit
    memory = local.memory_limit
  }
}
