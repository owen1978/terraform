# 02 — Terraform Intermediate: Variable-Driven Azure Web VM

A step up from `01_basics`: the same network + compute stack, but rebuilt as a properly
structured Terraform configuration — split into purpose-specific files and driven entirely
by variables instead of hardcoded values.

## What this deploys

The same web-server stack as `01_basics`, split across `network.tf`, `compute.tf`,
`variables.tf`, `outputs.tf`, and `terraform.tfvars`:

- **2 resource groups** — one for networking, one for the VM
- **Virtual network + subnet**
- **Network Security Group** with an inbound rule allowing HTTP (port 80) associated to the subnet
- **Public IP** (static) and **network interface** for the VM
- **Linux VM** (Ubuntu 22.04 LTS, `Standard_B2ms`), provisioned with:
  - SSH key-based authentication (no passwords)
  - A cloud-init custom data script (`customdata.tpl`) that installs and starts **nginx**
    automatically on first boot

Every value — names, locations, address ranges, NSG rule properties, VM sizing/image — is
supplied through a `variable` block and populated in `terraform.tfvars`, rather than being
written directly into the resource definitions.

## What this demonstrates

- Splitting a single-file configuration into purpose-specific files (`network.tf`,
  `compute.tf`, `variables.tf`, `outputs.tf`) for readability and maintainability
- Declaring typed `variable` blocks (`string`, `number`, `list(string)`) instead of relying
  on Terraform's implicit type inference
- Driving a deployment entirely through `terraform.tfvars` rather than hardcoded values —
  the same configuration can be re-pointed at a different environment just by swapping the
  `.tfvars` file
- The same Azure fundamentals as `01_basics`: resource groups, VNets, subnets, NSGs, public
  IPs, NICs, VMs, and how they reference each other
- Automated provisioning with cloud-init (`custom_data`) at boot time
- SSH key authentication over password-based access

## Running it

```bash
cd 02_intermediate
terraform init
terraform plan
terraform apply
```

Requires:
- An Azure subscription authenticated via the `azurerm` provider (e.g. `az login`)
- An SSH key pair at `~/.ssh/azurekey.pub` (referenced by the VM's `admin_ssh_key` block)

State files and the `.terraform/` cache are excluded from version control (see repo root
`.gitignore`). `terraform.tfvars` is intentionally tracked here so the variable composition
is visible as part of this portfolio — it contains no secrets, only resource names, regions,
and CIDR ranges.

## Where this fits

Step two in the progression through this repo:

1. **`01_basics`** — a single flat `main.tf`, everything hardcoded, to learn what each Azure
   resource does and how they connect.
2. **`02_intermediate`** *(this project)* — building on the basics with a properly
   structured, variable-driven deployment.
