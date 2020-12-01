locals{
  cartel_hosts = compact(var.hosts)
}

data "template_file" "config" {
  count = length(local.cartel_hosts)
  template = file("${path.module}/scripts/config.yml")
  vars = {
    container_name = element(split("-",element(local.cartel_hosts, count.index)),0)
  }
}

data "template_file" "exporter_bash" {
  count = length(compact(local.cartel_hosts))
  template = file("${path.module}/scripts/container_exporter.sh")
  vars = {
    container_name = element(split("-",element(local.cartel_hosts, count.index)),0)
  }
}

resource "null_resource" "container_exporter" {
  count = length(compact(local.cartel_hosts))

  triggers = {
    container_hosts = join(",", local.cartel_hosts.*)
  }

  connection {
    bastion_host = var.bastion_host
    host         = element(local.cartel_hosts, count.index)
    user         = var.user
    private_key  = file(var.private_key)
    script_path  = "/home/${var.user}/host_container.sh"
  }

  provisioner "file" {
    content     =  data.template_file.exporter_bash[count.index].rendered
    destination = "/home/${var.user}/container_exporter.sh"
  }

  provisioner "file" {
    content      = data.template_file.config[count.index].rendered
    destination = "/home/${var.user}/config.yml"
  }

  provisioner "remote-exec" {
    # Deploy container exporter for nodes
    inline = [
      "chmod +x /home/${var.user}/container_exporter.sh",
      "/home/${var.user}/container_exporter.sh ${element(local.cartel_hosts, count.index)}"
    ]
  }
}