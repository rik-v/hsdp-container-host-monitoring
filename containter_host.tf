locals{
  cartel_hosts = compact(var.hosts)
}

resource "null_resource" "container_exporter" {
  count = length(compact(local.cartel_hosts))

  triggers = {
    container_hosts = join(",", local.cartel_hosts.*)
    bash_files = file("${path.module}/scripts/container_exporter.sh")
  }

  connection {
    bastion_host = var.bastion_host
    host         = element(local.cartel_hosts, count.index)
    user         = var.user
    private_key  = file(var.private_key)
    script_path  = "/home/${var.user}/host_container.sh"
  }

  provisioner "file" {
    source      =  "${path.module}/scripts/container_exporter.sh"
    destination = "/home/${var.user}/container_exporter.sh"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/config.yml.tmpl"
    destination = "/home/${var.user}/config.yml.tmpl"
  }

  provisioner "remote-exec" {
    # Deploy container exporter for nodes
    inline = [
      "chmod +x /home/${var.user}/container_exporter.sh",
      "/home/${var.user}/container_exporter.sh"
    ]
  }
}