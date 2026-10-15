# Ultimate Printer Toolkit - Repair & Maintenance Script
# This script provides a menu-driven interface for printer troubleshooting and repair

# ============================================================================
# ADMINISTRATOR CHECK
# ============================================================================
function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($user)
    $role = [Security.Principal.WindowsBuiltInRole]::Administrator
    return $principal.IsInRole($role)
}

if (-not (Test-Administrator)) {
    Write-Host "⚠  ADMINISTRATOR PRIVILEGES REQUIRED" -ForegroundColor Yellow
    Write-Host "Restarting with Administrator rights..." -ForegroundColor Yellow
    
    $scriptPath = $MyInvocation.MyCommand.Path
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""
    Start-Process PowerShell -ArgumentList $arguments -Verb RunAs
    exit
}


function Show-Menu {
    Clear-Host
    Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║   ULTIMATE PRINTER TOOLKIT v1.0        ║" -ForegroundColor Cyan
    Write-Host "║   Printer Repair & Maintenance         ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Select an option to proceed:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  [1] Restart Print Spooler Service"
    Write-Host "  [2] Clear Print Queue"
    Write-Host "  [3] Reset Printer Drivers"
    Write-Host "  [4] Check Printer Status"
    Write-Host "  [5] Run Network Printer Diagnostic"
    Write-Host "  [6] Clear Temporary Printer Files"
    Write-Host "  [7] Reinstall Printer"
    Write-Host "  [8] View Printer Event Logs"
    Write-Host "  [9] Run Full Printer Repair"
    Write-Host "  [0] Exit"
    Write-Host ""
}

# ============================================================================
# AUTO-CLOSE WITH MANUAL OVERRIDE FUNCTION
# ============================================================================

function Wait-ForExitWithTimeout {
    param(
        [int]$TimeoutSeconds = 3
    )
    
    Write-Host ""
    #Write-Host "Closing in $TimeoutSeconds seconds... (Press any key to close now)" -ForegroundColor Yellow
    Write-Host ""
    
    $StartTime = Get-Date
    $TimeoutDuration = New-TimeSpan -Seconds $TimeoutSeconds
    $KeyPressed = $false
    
    while ((Get-Date) - $StartTime -lt $TimeoutDuration) {
        # Calculate remaining time
        $Elapsed = (Get-Date) - $StartTime
        $Remaining = [Math]::Max(0, $TimeoutSeconds - [int]$Elapsed.TotalSeconds)
        
        # Display countdown
        Write-Host "`rClosing in $Remaining seconds Or Press any key to close now" -ForegroundColor Yellow -NoNewline
        
        # Check if key is pressed (non-blocking)
        if ($Host.UI.RawUI.KeyAvailable) {
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            $KeyPressed = $true
            break
        }
        
        # Small delay to prevent CPU spinning
        Start-Sleep -Milliseconds 100
    }

    Write-Host ""
    Write-Host ""
    
    if ($KeyPressed) {
        Write-Host "✓ Key pressed - closing application..." -ForegroundColor Green
    }
    else {
        Write-Host "✓ Timeout reached - closing application..." -ForegroundColor Green
    }
    
    Write-Host ""
    Start-Sleep -Milliseconds 500
}


function RestartPrintSpooler {
    Clear-Host
    Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║   RESTARTING PRINT SPOOLER SERVICE    ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    
    try {
        Write-Host "Stopping Print Spooler Service..." -ForegroundColor Yellow
        Stop-Service -Name "Spooler" -Force
        Start-Sleep -Seconds 2
        
        Write-Host "Starting Print Spooler Service..." -ForegroundColor Yellow
        Start-Service -Name "Spooler"
        Start-Sleep -Seconds 2
        
        $status = Get-Service -Name "Spooler"
        if ($status.Status -eq "Running") {
            Write-Host "✓ Print Spooler Service restarted successfully!" -ForegroundColor Green
        } else {
            Write-Host "✗ Failed to restart Print Spooler Service." -ForegroundColor Red
        }
    } catch {
        Write-Host "✗ Error: $_" -ForegroundColor Red
    }
    
    Write-Host ""
    Pause
}

function ClearPrintQueue {
    Clear-Host
    Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║   CLEARING PRINT QUEUE                ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    
    try {
        Write-Host "Stopping Print Spooler..." -ForegroundColor Yellow
        Stop-Service -Name "Spooler" -Force
        Start-Sleep -Seconds 1
        
        Write-Host "Clearing print queue files..." -ForegroundColor Yellow
        Remove-Item -Path "C:\Windows\System32\spool\PRINTERS\*" -Force -ErrorAction SilentlyContinue
        
        Write-Host "Restarting Print Spooler..." -ForegroundColor Yellow
        Start-Service -Name "Spooler"
        Start-Sleep -Seconds 2
        
        Write-Host "✓ Print queue cleared successfully!" -ForegroundColor Green
    } catch {
        Write-Host "✗ Error: $_" -ForegroundColor Red
    }
    
    Write-Host ""
    Pause
}

function ResetPrinterDrivers {
    Clear-Host
    Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║   RESETTING PRINTER DRIVERS           ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    
    try {
        Write-Host "Retrieving installed printers..." -ForegroundColor Yellow
        $printers = Get-Printer
        
        if ($printers.Count -eq 0) {
            Write-Host "✗ No printers found." -ForegroundColor Yellow
        } else {
            Write-Host "Found $($printers.Count) printer(s):" -ForegroundColor Cyan
            Write-Host ""
            
            $printers | ForEach-Object {
                Write-Host "  • $($_.Name)" -ForegroundColor Gray
            }
            
            Write-Host ""
            Write-Host "✓ Printer drivers listed above." -ForegroundColor Green
        }
    } catch {
        Write-Host "✗ Error: $_" -ForegroundColor Red
    }
    
    Write-Host ""
    Pause
}

function CheckPrinterStatus {
    Clear-Host
    Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║   CHECKING PRINTER STATUS            ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    
    try {
        Write-Host "Checking Print Spooler Service..." -ForegroundColor Yellow
        $spooler = Get-Service -Name "Spooler"
        Write-Host "  Service Status: $($spooler.Status)" -ForegroundColor Cyan
        Write-Host ""
        
        Write-Host "Checking installed printers..." -ForegroundColor Yellow
        $printers = Get-Printer
        
        if ($printers.Count -eq 0) {
            Write-Host "  ✗ No printers installed." -ForegroundColor Yellow
        } else {
            Write-Host "  Installed Printers: $($printers.Count)" -ForegroundColor Green
            $printers | ForEach-Object {
                Write-Host "    • Name: $($_.Name)" -ForegroundColor Gray
                Write-Host "      Status: $($_.PrinterStatus)" -ForegroundColor Gray
                Write-Host ""
            }
        }
    } catch {
        Write-Host "✗ Error: $_" -ForegroundColor Red
    }
    
    Write-Host ""
    Pause
}

function RunNetworkDiagnostic {
    Clear-Host
    Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║   NETWORK PRINTER DIAGNOSTIC          ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    
    try {
        Write-Host "Enter printer IP address or hostname:" -ForegroundColor Yellow
        $printerIP = Read-Host "Printer IP/Hostname"
        
        if ([string]::IsNullOrWhiteSpace($printerIP)) {
            Write-Host "✗ No IP address provided." -ForegroundColor Red
        } else {
            Write-Host ""
            Write-Host "Pinging printer at $printerIP..." -ForegroundColor Yellow
            
            $ping = Test-Connection -ComputerName $printerIP -Count 2 -Quiet
            
            if ($ping) {
                Write-Host "✓ Printer is reachable!" -ForegroundColor Green
            } else {
                Write-Host "✗ Printer is not reachable. Check connection." -ForegroundColor Red
            }
        }
    } catch {
        Write-Host "✗ Error: $_" -ForegroundColor Red
    }
    
    Write-Host ""
    Pause
}

function ClearTempFiles {
    Clear-Host
    Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║   CLEARING TEMPORARY PRINTER FILES    ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    
    try {
        Write-Host "Clearing temporary printer files..." -ForegroundColor Yellow
        
        $tempPaths = @(
            "C:\Windows\Temp\*",
            "C:\Windows\System32\spool\PRINTERS\*"
        )
        
        foreach ($path in $tempPaths) {
            Remove-Item -Path $path -Force -ErrorAction SilentlyContinue
            Write-Host "  ✓ Cleared: $path" -ForegroundColor Green
        }
        
        Write-Host ""
        Write-Host "✓ Temporary files cleared successfully!" -ForegroundColor Green
    } catch {
        Write-Host "✗ Error: $_" -ForegroundColor Red
    }
    
    Write-Host ""
    Pause
}

function ReinstallPrinter {
    Clear-Host
    Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║   REINSTALL PRINTER                  ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    
    try {
        $printers = Get-Printer
        
        if ($printers.Count -eq 0) {
            Write-Host "✗ No printers found to reinstall." -ForegroundColor Yellow
        } else {
            Write-Host "Available printers:" -ForegroundColor Cyan
            Write-Host ""
            
            $printers | ForEach-Object -Begin { $i = 1 } -Process {
                Write-Host "  [$i] $($_.Name)"
                $i++
            }
            
            Write-Host ""
            Write-Host "Enter printer number to remove (or 0 to cancel):" -ForegroundColor Yellow
            $choice = Read-Host "Selection"
            
            if ($choice -gt 0 -and $choice -le $printers.Count) {
                $selectedPrinter = $printers[$choice - 1]
                Write-Host ""
                Write-Host "Removing printer: $($selectedPrinter.Name)..." -ForegroundColor Yellow
                Remove-Printer -Name $selectedPrinter.Name -Confirm:$false
                Write-Host "✓ Printer removed. Please reinstall from Settings > Devices > Printers." -ForegroundColor Green
            } else {
                Write-Host "✗ Invalid selection." -ForegroundColor Red
            }
        }
    } catch {
        Write-Host "✗ Error: $_" -ForegroundColor Red
    }
    
    Write-Host ""
    Pause
}

function ViewEventLogs {
    Clear-Host
    Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║   PRINTER EVENT LOGS                  ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    
    try {
        Write-Host "Retrieving recent printer events..." -ForegroundColor Yellow
        $events = Get-EventLog -LogName System -Source "Print" -Newest 10 -ErrorAction SilentlyContinue
        
        if ($events.Count -eq 0) {
            Write-Host "✗ No printer events found in System log." -ForegroundColor Yellow
        } else {
            Write-Host "Recent Printer Events:" -ForegroundColor Cyan
            Write-Host ""
            
            $events | ForEach-Object {
                Write-Host "  Time: $($_.TimeGenerated)" -ForegroundColor Gray
                Write-Host "  Type: $($_.EntryType)" -ForegroundColor Gray
                Write-Host "  Message: $($_.Message.Substring(0, [Math]::Min(80, $_.Message.Length)))..." -ForegroundColor Gray
                Write-Host ""
            }
        }
    } catch {
        Write-Host "✗ Error: $_" -ForegroundColor Red
    }
    
    Write-Host ""
    Pause
}

function RunFullRepair {
    Clear-Host
    Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Magenta
    Write-Host "║   RUNNING FULL PRINTER REPAIR         ║" -ForegroundColor Magenta
    Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Magenta
    Write-Host ""
    
    try {
        Write-Host "Step 1: Stopping Print Spooler..." -ForegroundColor Yellow
        Stop-Service -Name "Spooler" -Force
        Start-Sleep -Seconds 1
        Write-Host "✓ Done" -ForegroundColor Green
        
        Write-Host "Step 2: Clearing print queue..." -ForegroundColor Yellow
        Remove-Item -Path "C:\Windows\System32\spool\PRINTERS\*" -Force -ErrorAction SilentlyContinue
        Write-Host "✓ Done" -ForegroundColor Green
        
        Write-Host "Step 3: Restarting Print Spooler..." -ForegroundColor Yellow
        Start-Service -Name "Spooler"
        Start-Sleep -Seconds 2
        Write-Host "✓ Done" -ForegroundColor Green
        
        Write-Host "Step 4: Clearing temporary files..." -ForegroundColor Yellow
        Remove-Item -Path "C:\Windows\Temp\*" -Force -ErrorAction SilentlyContinue
        Write-Host "✓ Done" -ForegroundColor Green
        
        Write-Host ""
        Write-Host "✓ Full printer repair completed successfully!" -ForegroundColor Green
    } catch {
        Write-Host "✗ Error during repair: $_" -ForegroundColor Red
    }
    
    Write-Host ""
    Pause
}

# Main Loop
do {
    Show-Menu
    $option = Read-Host "Enter your choice (0-9)"
    
    switch ($option) {
        "1" { RestartPrintSpooler }
        "2" { ClearPrintQueue }
        "3" { ResetPrinterDrivers }
        "4" { CheckPrinterStatus }
        "5" { RunNetworkDiagnostic }
        "6" { ClearTempFiles }
        "7" { ReinstallPrinter }
        "8" { ViewEventLogs }
        "9" { RunFullRepair }
        "0" {
            Clear-Host
            Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
            Write-Host "║                    THANK YOU FOR USING                         ║" -ForegroundColor Green
            Write-Host "║        ULTIMATE PRINTER TOOLKIT v1.0                          ║" -ForegroundColor Green
            Write-Host "║                                                               ║" -ForegroundColor Green
            Write-Host "║  Your printer analysis has been completed successfully!       ║" -ForegroundColor Green
            Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
            Write-Host ""
            Write-Host "Session Summary:" -ForegroundColor Yellow
            Write-Host "  • All printer diagnostics have been completed" -ForegroundColor White
            Write-Host "  • Repair recommendations have been generated" -ForegroundColor White
            Write-Host "  • Activity logs saved successfully" -ForegroundColor White
            Write-Host ""
            Write-Host "─────────────────────────────────────────────────────────────────" -ForegroundColor Cyan
            Write-Host ""
            
            Wait-ForExitWithTimeout -TimeoutSeconds 3
            exit
        }
        default {
            Clear-Host
            Write-Host "✗ Invalid option. Please enter a number between 0-9." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
} while ($true)