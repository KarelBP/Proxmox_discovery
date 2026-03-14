# Proxmox discovery
Proxmox discovery pattern for ServiceNow. The XML files in this repository are update sets. You need sudo installed on your Proxmox host and a user with permissions as described at https://www.servicenow.com/docs/bundle/zurich-platform-security/page/product/credentials/reference/r_SSHCredentialsForm.html



## Files
Proxmox VE.xml => main discovery pattern for Proxmox VE; add as an extension to OOTB pattern Linux Server

Create references between Proxmox and Linux (KVM) => Pre/Post script to pair cmdb_ci_kvm object of Proxmox with underlying Linux host

Create references between Proxmox and Linux (LXC) => Pre/Post script to pair cmdb_ci_oslv_engine object of Proxmox with underlying Linux host

Proxmox VMs config.xml => script to get config of VM instances; goes to MID Server Script Files, parent SSHScriptFiles

Proxmox CTs config.xml => script to get config of CT instances; goes to MID Server Script Files, parent SSHScriptFiles

Get Object Id for QEMU Linux Server.xml => pattern to pair discovered Linux Server with VM instance; add as an extension to OOTB pattern Linux Server

Get Object Id for QEMU Windows Server.xml => pattern to pair discovered Windows Server with VM instance; add as an extension to OOTB pattern Windows OS - Servers

Proxmox LXC detection.xml => pattern to detect if discovered Linux server is a container and not a full OS; add as an extension to OOTB pattern Linux Server; assumes the discovery account can SSH to containers like to any other Linux

Create relation between server and container.xml => Pre/Post script to pair cmdb_ci_oslv_container with cmdb_ci_linux_server

disco_linux.sh => script to give user 'disco' necessary sudo permissions



## Articles
Part 1 - [Enterprise Ready](https://www.linkedin.com/pulse/enterprise-ready-karel-bene%C5%A1-8cgyf/) - Introduction

Part 2 - [Know Your Enemy](https://www.linkedin.com/pulse/know-your-enemy-karel-bene%C5%A1-pqzcf/) - Discovering Linux + Event Management

Part 3 - [Keyboard. Video. Mouse.](https://www.linkedin.com/pulse/keyboard-video-mouse-karel-bene%C5%A1-moqnf/) - Discovering KVM

Part 4 - [1600 Newton-meters at 6000 RPM](https://www.linkedin.com/pulse/1600-newton-meters-6000-rpm-karel-bene%C5%A1-es5vf/) - Discovering LXC
