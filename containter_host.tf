resource "null_resource" "container_exporter" {
  count = length(var.hosts)

  triggers = {
    container_hosts = join(",", var.hosts.*)
  }

  connection {
    bastion_host = var.bastion_host
    host         = element(var.hosts, count.index)
    user         = var.user
    private_key  = file(var.private_key)
    script_path  = "/home/${var.user}/host_container.sh"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/container_exporter.sh"
    destination = "/home/${var.user}/container_exporter.sh"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/config.yml"
    destination = "/home/${var.user}/config.yml"
  }

  provisioner "remote-exec" {
    # Deploy container exporter for nodes
    inline = [
      "chmod +x /home/${var.user}/container_exporter.sh",
      "/home/${var.user}/container_exporter.sh ${element(var.hosts, count.index)}"
    ]
  }
}