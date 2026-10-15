# 🖨️ Ultimate Printer Toolkit

> 🔒 **PROPRIETARY SOFTWARE — NOT OPEN SOURCE**  
> Copyright © 2026 VALOR. All Rights Reserved.

**Ultimate Printer Toolkit** is a Windows PowerShell-based printer troubleshooting and maintenance utility designed to help technicians and users diagnose and resolve common Windows printing problems.

The toolkit provides a menu-driven interface for restarting the Print Spooler, clearing stuck print jobs, checking printer status, testing network-printer connectivity, reviewing printer-related events, removing printers for reinstallation, and performing common repair actions.

---

# ✨ Features

## 🔄 1. Restart Print Spooler Service

Stops and restarts the Windows **Print Spooler** service.

This can help resolve common printing issues such as:

- Print jobs not processing
- Printer appearing offline
- Printer queue becoming unresponsive
- Print Spooler service problems
- Documents remaining stuck in the queue

The tool verifies whether the Print Spooler is running after the restart.

---

## 🧹 2. Clear Print Queue

Stops the Print Spooler and removes pending spool files from:

```text
C:\Windows\System32\spool\PRINTERS\
```

The Print Spooler is then restarted.

Useful for resolving:

- Stuck print jobs
- Print jobs that cannot be cancelled
- Corrupted spool files
- Repeated print queue errors

> Clearing the print queue removes pending print jobs.

---

## 🖨️ 3. View Installed Printers

Displays the printers currently detected by Windows.

The tool lists installed printer names so users or technicians can review the current printer configuration.

> The current version lists installed printers under the **Reset Printer Drivers** menu option. It does not currently uninstall or reinstall printer drivers automatically.

---

## 📊 4. Check Printer Status

Checks the current Windows printing environment.

The tool displays:

- Print Spooler service status
- Number of installed printers
- Printer names
- Printer status information reported by Windows

This can help identify whether Windows recognizes the configured printer devices.

---

## 🌐 5. Network Printer Diagnostic

Tests connectivity to a network printer using an IP address or hostname.

The user can enter:

```text
Printer IP Address
```

or:

```text
Printer Hostname
```

The toolkit then performs a basic network reachability test.

Example:

```text
Printer IP/Hostname: 192.168.1.50
```

Possible results include:

```text
✓ Printer is reachable!
```

or:

```text
✗ Printer is not reachable. Check connection.
```

This can help identify basic:

- Network connectivity problems
- Incorrect printer IP addresses
- Offline network printers
- DNS/hostname resolution problems
- Connection failures

> A successful ping confirms network reachability only. It does not guarantee that the printer service, print port, driver, or printing protocol is functioning correctly.

---

## 🧽 6. Clear Temporary Files

Removes files from selected Windows temporary and print-spool directories.

Current cleanup locations include:

```text
C:\Windows\Temp\*
```

and:

```text
C:\Windows\System32\spool\PRINTERS\*
```

This may help remove temporary files and stale print-spool data.

> ⚠️ The current implementation clears the general Windows temporary directory as well as printer spool files. Users should understand this behavior before running the option.

---

## ♻️ 7. Remove Printer for Reinstallation

Displays installed printers and allows the user to select a printer for removal.

The toolkit uses Windows printer-management commands to remove the selected printer.

After removal, the user can reinstall the printer through Windows Settings.

Typical path:

```text
Settings
   ↓
Bluetooth & devices
   ↓
Printers & scanners
```

This can help with:

- Corrupted printer configurations
- Incorrect printer installations
- Printer configuration problems
- Reinstallation troubleshooting

> This function removes the selected printer configuration. It does not automatically download or reinstall manufacturer drivers.

---

## 📋 8. View Printer Event Logs

Attempts to retrieve recent printer-related events from the Windows System event log.

The toolkit can display information such as:

- Event time
- Event type
- Event message

This may help technicians identify Windows printing errors or service problems.

> Event availability depends on the Windows version, enabled event channels, and how printer events are recorded on the system.

---

## 🛠️ 9. Full Printer Repair

Runs several common printer-repair actions in sequence.

The current repair process performs:

```text
Step 1
Stop Print Spooler

       ↓

Step 2
Clear Print Queue

       ↓

Step 3
Restart Print Spooler

       ↓

Step 4
Clear Windows Temporary Files
```

This option is designed as a quick maintenance procedure for common Windows printing problems.

> It does not automatically reinstall printer drivers or repair hardware problems.

---

# 🖥️ Main Menu

The application provides the following menu:

```text
╔════════════════════════════════════════╗
║   ULTIMATE PRINTER TOOLKIT v1.0       ║
║   Printer Repair & Maintenance        ║
╚════════════════════════════════════════╝

[1] Restart Print Spooler Service
[2] Clear Print Queue
[3] Reset Printer Drivers
[4] Check Printer Status
[5] Run Network Printer Diagnostic
[6] Clear Temporary Printer Files
[7] Reinstall Printer
[8] View Printer Event Logs
[9] Run Full Printer Repair
[0] Exit
```

---

# 🛡️ Administrator Privileges

Ultimate Printer Toolkit requires **Windows Administrator privileges**.

When the script detects that it is not running as Administrator, it automatically requests elevation through Windows User Account Control (UAC).

The script restarts itself using:

```text
Run as Administrator
```

Administrator privileges are required because the toolkit performs actions involving:

- Windows services
- Print Spooler files
- Windows temporary files
- Installed printers
- Printer removal
- System event information

---

# 💻 Requirements

Recommended environment:

- Windows 10
- Windows 11
- Windows PowerShell
- Administrator privileges
- Windows Print Spooler service
- Windows printer-management cmdlets

Some printer-management commands may depend on the Windows **PrintManagement** components being available.

---

# 🚀 How to Run

Download or clone the repository.

Open PowerShell and navigate to the project directory.

Run:

```powershell
.\UltimatePrinterToolkit.ps1
```

The script may request Administrator privileges automatically.

---

# 🔄 Typical Troubleshooting Workflow

```text
Printer Problem
      │
      ▼
Check Printer Status
      │
      ├── Spooler Running?
      │
      ├── Printer Installed?
      │
      └── Printer Status?
      │
      ▼
Restart Print Spooler
      │
      ▼
Clear Print Queue
      │
      ▼
Network Printer?
      │
      ├── Yes ──► Run Network Diagnostic
      │
      └── No
      │
      ▼
Review Event Logs
      │
      ▼
Remove / Reinstall Printer if Required
      │
      ▼
Run Full Repair if Appropriate
```

---

# 🔧 Common Problems This Toolkit May Help With

The toolkit may assist with troubleshooting issues such as:

- Printer not printing
- Print jobs stuck in queue
- Printer showing offline
- Print Spooler stopped
- Network printer unreachable
- Corrupted spool files
- Printer configuration problems
- Printer removal and reinstallation
- Printer-related Windows errors

---

# ⚠️ Important Limitations

Ultimate Printer Toolkit is a troubleshooting and maintenance utility.

It does **not** guarantee repair of every printer problem.

It does not automatically diagnose or repair:

- Physical printer hardware failures
- Damaged USB cables
- Faulty network equipment
- Ink or toner problems
- Paper jams
- Manufacturer firmware problems
- All printer-driver problems
- Printer hardware sensors
- Mechanical failures
- Manufacturer-specific software problems

Some repairs may still require:

- Manufacturer printer software
- Official printer drivers
- Firmware updates
- Hardware servicing
- Network configuration
- Printer replacement

---

# ⚠️ Temporary File Cleanup Notice

The current version removes files from:

```text
C:\Windows\Temp\*
```

during the temporary-file cleanup and full-repair functions.

This directory is a general Windows temporary directory and is not exclusively used for printer files.

Users should close important applications before running cleanup operations.

Some files that are currently in use may not be removed.

---

# 🔐 Security & Safety

This toolkit is intended for:

- Authorized Windows troubleshooting
- IT support
- Printer maintenance
- System administration
- Educational use
- Technical support environments

Review the PowerShell source code before running it on production systems.

Because the application requires Administrator privileges, it should only be run from a trusted source.

---

# 🧑‍💻 Technician Use

Ultimate Printer Toolkit can be useful for IT technicians who perform:

- Remote printer troubleshooting
- Desktop support
- Windows maintenance
- Office printer support
- Network printer diagnostics
- Print queue cleanup
- Spooler troubleshooting

The application is designed to place common printer-repair tasks into a simple menu-driven interface.

---


> 🔒 **This repository may be publicly visible on GitHub, but the software remains proprietary. Public access does not grant permission to modify, redistribute, or re-license the source code.**

Please contact the copyright holder if you are interested in authorized modification, development, collaboration, integration, redistribution, or licensing.

---

# 🚫 Proprietary Software Notice

**Ultimate Printer Toolkit** is proprietary software developed by **VALOR**.

Copyright © 2026 VALOR. All Rights Reserved.

This project is **not open-source software**.

The source code is publicly viewable only where made available by the copyright holder.

Unless expressly authorized in writing, you may not:

- Copy the source code
- Modify the source code
- Create derivative works
- Redistribute the software
- Repackage the software
- Sell the software
- Publish modified versions
- Incorporate the source code into another product
- Sublicense the software
- Remove or alter copyright notices
- Re-license the project
- Release modified versions under an open-source license
- Convert the project into an open-source project

No permission is granted under:

- MIT
- Apache-2.0
- GPL
- LGPL
- BSD
- Or another open-source license

All rights not expressly granted are reserved by the copyright holder.

See the `LICENSE` file for the complete licensing terms.

---

# 📜 License

This project is distributed under a **proprietary license**.

Copyright © 2026 VALOR. All Rights Reserved.

No open-source license is granted.

Modification, redistribution, commercial use, derivative development, integration, or other use outside the permissions granted by the proprietary license requires written authorization from the copyright holder.

---

# 👤 Project Information

**Project Name:** Ultimate Printer Toolkit  
**Version:** 1.0  
**Developer:** VALOR  
**Language:** PowerShell  
**Platform:** Windows  
**Category:** Printer Troubleshooting & Maintenance  
**Copyright:** © 2026 VALOR

---

# 🔒 Copyright

Copyright © 2026 VALOR. All Rights Reserved.

**Ultimate Printer Toolkit is proprietary software and is not open source.**
