# Terraform Labs

A personal Terraform learning repo — hands-on infrastructure-as-code exercises on Azure
(with AWS planned), building from single-file basics up to reusable module architecture.

## Author

**Shofi Alom**
Portfolio: [headinclouds.xyz](https://headinclouds.xyz)

## Purpose

This repo tracks my progression learning Terraform from first principles: provisioning real
Azure infrastructure, understanding how resources reference each other, and gradually
introducing the patterns (variables, `for_each`, reusable modules) that make configurations
maintainable at scale. Each numbered folder is a self-contained step up in complexity.

## Structure

- **`01_basics`** — A single flat `main.tf` provisioning a full network + compute stack
  (resource groups, VNet, subnet, NSG, public IP, NIC, Linux VM) with a cloud-init script that
  installs nginx on boot. Everything hardcoded, to learn what each Azure resource does and how
  they connect. See [`01_basics/README.md`](01_basics/README.md) for details.
- **`02_intermediate`** — Splitting configuration into purpose-specific files
  (`network.tf`, `compute.tf`, `variables.tf`, `outputs.tf`) and driving values through
  `terraform.tfvars` instead of hardcoding.

## Notes

- State files (`.tfstate`), the `.terraform/` cache, and provider lock files are excluded from
  version control — see `.gitignore`.
- `.tfvars` files in this repo are intentionally tracked (not gitignored) so the variable
  compositions are visible as part of this portfolio. They contain no secrets or credentials —
  only resource names, regions, and CIDR ranges.
