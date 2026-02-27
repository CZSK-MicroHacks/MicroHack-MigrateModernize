# MicroHack - Migrate & Modernize Lab Instructions

## Overview

This MicroHack lab demonstrates Azure migration and modernization scenarios using on-premises simulated environments.

**Repository**: [https://github.com/CZSK-MicroHacks/MicroHack-MigrateModernize](https://github.com/CZSK-MicroHacks/MicroHack-MigrateModernize)

---

## Student Access Information

### Azure Portal Login

**Portal URL**: [https://portal.azure.com](https://portal.azure.com)

**Credentials**:
- **Username**: `UserXXX@MngEnvMCAP346784.onmicrosoft.com` (where XXX = 001-055)
- **Password**: `********` (will be shared later)

**Important**: Configure Multi-Factor Authentication (MFA) with Microsoft Authenticator upon first login.

---

## Resource Group Structure

### On-Premises Simulation Environment

- **Resource Group**: `rg-onpremXX` (where XX = 1-15)
- **Purpose**: Contains VMs that simulate on-premises Hyper-V environments
- **Access**: Shared between 3 students per resource group
- **User Assignment**:
  - `rg-onprem1` → User001, User002, User003
  - `rg-onprem2` → User004, User005, User006
  - `rg-onprem3` → User007, User008, User009
  - ...
  - `rg-onprem15` → User043, User044, User045

### Target Migration Environment

- **Resource Group**: `rg-userXXX` (where XXX = 001-055)
- **Purpose**: Personal resource group for each student to deploy migrated/modernized workloads
- **Access**: Individual Contributor access per student
- **Location**: Sweden Central

---

## Lab Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Azure Subscription                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌───────────────────┐        ┌─────────────────────────────┐  │
│  │  rg-onprem1       │        │  rg-user001                 │  │
│  │  (Shared)         │        │  (Individual)               │  │
│  │  • User001 ───────┼──────▶│  • User001                  │   │
│  │  • User002 ───────┼────┐   │                             │   │
│  │  • User003 ───────┼──┐ │   └─────────────────────────────┘   │
│  │                   │  │ │                                     │
│  │  [Hyper-V VM]     │  │ └──▶┌─────────────────────────────┐  │
│  └───────────────────┘  │     │  rg-user002                 │  │
│                         │     │  (Individual)               │  │
│  ┌───────────────────┐  │     │  • User002                  │  │
│  │  rg-onprem2       │  │     └─────────────────────────────┘  │
│  │  (Shared)         │  │                                       │
│  │  • User004        │  └────▶┌─────────────────────────────┐  │
│  │  • User005        │         │  rg-user003                 │  │
│  │  • User006        │         │  (Individual)               │  │
│  │                   │         │  • User003                  │  │
│  │  [Hyper-V VM]     │         └─────────────────────────────┘  │
│  └───────────────────┘                                          │
│                                                                 │
│  ... (continues for 15 on-premises RGs and 55 user RGs)         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```
