# Resource: Control Plane VMs
resource "proxmox_virtual_environment_vm" "control_plane" {
  count     = var.control_plane_count
  name      = "cp-${count.index}"
  node_name = var.node_name
  vm_id     = 200 + count.index

  cpu {
    cores = 2
  }

  memory {
    dedicated = 4096
  }

  agent {
    enabled = false
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 20
    file_format  = "raw"
  }

  cdrom {
    enabled = true
    file_id = "local:iso/talos-amd64.iso"
  }

  # Define a ordem de boot: Disco primeiro, depois CDROM
  boot_order = ["scsi0", "ide2"] 
}

# Resource: Worker VMs
resource "proxmox_virtual_environment_vm" "worker" {
  count     = var.worker_count
  name      = "worker-${count.index}"
  node_name = var.node_name
  vm_id     = 300 + count.index

  cpu {
    cores = 4
  }

  memory {
    dedicated = 8192
  }

  agent {
    enabled = false
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 50
    file_format  = "raw"
  }

  cdrom {
    enabled = true
    file_id = "local:iso/talos-amd64.iso"
  }

  boot_order = ["scsi0", "ide2"]
}
