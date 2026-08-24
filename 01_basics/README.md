# 01 — Terraform Basics: Azure Web VM

This is my first hands-on Terraform project, built to learn core infrastructure-as-code
concepts by provisioning a working web server on Azure from scratch.

## What this deploys

A single `main.tf` provisions a small but complete network + compute stack in Azure:

- **2 resource groups** — one for networking, one for the VM (separating concerns by lifecycle)
- **Virtual network + subnet** (`10.0.0.0/16`, subnet `10.0.1.0/24`)
- **Network Security Group** with an inbound rule allowing HTTP (port 80) associated to the subnet
- **Public IP** (static) and **network interface** for the VM
- **Linux VM** (Ubuntu 22.04 LTS, `Standard_B2ms`), provisioned with:
  - SSH key-based authentication (no passwords)
  - A **cloud-init custom data script** (`customdata.tpl`) that installs and starts **nginx**
    automatically on first boot

The end result: run `terraform apply`, wait for the VM to boot, and hit the public IP in a
browser to see nginx's default page — no manual server setup required.

## What this demonstrates

- Core Terraform workflow: `init`, `plan`, `apply`, `validate`
- Azure resource modeling: resource groups, VNets, subnets, NSGs, public IPs, NICs, and VMs,
  and how they reference each other
- Network security fundamentals: locking inbound access down to specific ports via NSG rules
  rather than leaving everything open
- Automated provisioning with **cloud-init** (`custom_data`) to configure a VM at boot time
  instead of manual post-deploy steps
- SSH key authentication over password-based access
- Resource tagging for environment tracking (`environment = "dev"`)

## Running it

```bash
cd 01_basics
terraform init
terraform plan
terraform apply
```

Requires:
- An Azure subscription authenticated via the `azurerm` provider (e.g. `az login`)
- An SSH key pair at `~/.ssh/azurekey.pub` (referenced by the VM's `admin_ssh_key` block)

State files, `.terraform/`, and any `.tfvars` are intentionally excluded from version control
(see repo root `.gitignore`) since they can contain sensitive or environment-specific data.

## Where this fits

This is step one in a progression through this repo:

1. **`01_basics`** *(this project)* — a single flat `main.tf`, everything hardcoded, to learn
   what each Azure resource does and how they connect.
2. **`02_intermediate`** — building on the basics with more configurable, variable-driven
   deployments.
3. **`03_advanced`** — reusable Terraform **modules** (`_modules/azure/...`), `for_each`-driven
   multi-resource deployments, and module composition patterns.
