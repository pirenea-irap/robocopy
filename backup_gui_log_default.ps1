# Force l'encodage UTF-8 pour la console
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# (Facultatif) Active un style de texte vert comme dans le .bat
Write-Host "`n[INFO] Start backup..." -ForegroundColor Green

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

# === Répertoires par défaut (PILAB ou PIRENEA) ===
$srcFolder = "D:\PIRENEA\truc"
$destFolder = "Z:\PIRENEA_truc"

# === Créer la fenêtre principale ===
$form = New-Object System.Windows.Forms.Form
$form.Text = "Backup Tool"
$form.Width = 550
$form.Height = 350
$form.StartPosition = "CenterScreen"

# === Label et bouton pour choisir la source ===
$lblSrc = New-Object System.Windows.Forms.Label
$lblSrc.Text = "Source Directory:"
$lblSrc.Left = 10
$lblSrc.Top = 20
$lblSrc.Width = 120

$txtSrc = New-Object System.Windows.Forms.TextBox
$txtSrc.Left = 130
$txtSrc.Top = 18
$txtSrc.Width = 290
$txtSrc.Text = $srcFolder

$btnSrc = New-Object System.Windows.Forms.Button
$btnSrc.Text = "Select..."
$btnSrc.Left = 430
$btnSrc.Top = 16
$btnSrc.Width = 90

# === Label et bouton pour choisir la destination ===
$lblDest = New-Object System.Windows.Forms.Label
$lblDest.Text = "Target Directory:"
$lblDest.Left = 10
$lblDest.Top = 60
$lblDest.Width = 120

$txtDest = New-Object System.Windows.Forms.TextBox
$txtDest.Left = 130
$txtDest.Top = 58
$txtDest.Width = 290
$txtDest.Text = $destFolder

$btnDest = New-Object System.Windows.Forms.Button
$btnDest.Text = "Select..."
$btnDest.Left = 430
$btnDest.Top = 56
$btnDest.Width = 90

# === Label et bouton pour choisir le fichier log ===
$lblLog = New-Object System.Windows.Forms.Label
$lblLog.Text = "Log file (.log):"
$lblLog.Left = 10
$lblLog.Top = 100
$lblLog.Width = 120

$txtLog = New-Object System.Windows.Forms.TextBox
$txtLog.Left = 130
$txtLog.Top = 98
$txtLog.Width = 290

$btnLog = New-Object System.Windows.Forms.Button
$btnLog.Text = "Select..."
$btnLog.Left = 430
$btnLog.Top = 96
$btnLog.Width = 90

# === Bouton pour lancer la sauvegarde ===
$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Text = "Start Backup"
$btnRun.Left = 180
$btnRun.Top = 150
$btnRun.Width = 180
$btnRun.Height = 40

# === Dialogues avec répertoire par défaut ===
$folderDialogSrc = New-Object System.Windows.Forms.FolderBrowserDialog
$folderDialogSrc.SelectedPath = $srcFolder

$folderDialogDest = New-Object System.Windows.Forms.FolderBrowserDialog
$folderDialogDest.SelectedPath = $destFolder

$saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
$saveFileDialog.FileName = "$env:TEMP\robocopy_temp.log"
$saveFileDialog.Filter = "Log file (*.log)|*.log"
$saveFileDialog.Title = "Select log Directory"
$saveFileDialog.OverwritePrompt = $true
$saveFileDialog.FileName = "$(Get-Location)\robocopy_temp.log"

$btnSrc.Add_Click({
    if ($folderDialogSrc.ShowDialog() -eq "OK") {
        $txtSrc.Text = $folderDialogSrc.SelectedPath
    }
})
$btnDest.Add_Click({
    if ($folderDialogDest.ShowDialog() -eq "OK") {
        $txtDest.Text = $folderDialogDest.SelectedPath
    }
})
$btnLog.Add_Click({
    if ($saveFileDialog.ShowDialog() -eq "OK") {
        $txtLog.Text = $saveFileDialog.FileName
    }
})

# === Action du bouton "Lancer la sauvegarde" ===
$btnRun.Add_Click({
    $src = $txtSrc.Text.Trim()
    $dest = $txtDest.Text.Trim()
    $logPath = $txtLog.Text.Trim()

    if (-not (Test-Path $src)) {
        [System.Windows.Forms.MessageBox]::Show("Source Directory is missing.","Erreur",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }
    if (-not (Test-Path $dest)) {
        [System.Windows.Forms.MessageBox]::Show("Target Directory is missing.","Erreur",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }
    if ([string]::IsNullOrWhiteSpace($logPath)) {
		[System.Windows.Forms.MessageBox]::Show("Please specify a log file.","Erreur",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error)
		return
	}
	
    # Lancer robocopy
    $args = "`"$src`" `"$dest`" /E /COPY:DAT /DCOPY:T /V /R:3 /W:5 /NP /NFL /LOG:`"$logPath`" /XC /XN /XO /XD `"System Volume Information`" `"$RECYCLE.BIN`""
	Start-Process -NoNewWindow -Wait -FilePath "robocopy.exe" -ArgumentList $args
	
	Write-Host "`nEnd of backup. `nLog file: $logPath" -ForegroundColor Green

    # Conversion OEM -> UTF-8 vers le fichier choisi
    # $encodingOEM = [System.Text.Encoding]::GetEncoding([Console]::OutputEncoding.CodePage)
    # $bytes = [System.IO.File]::ReadAllBytes($logOEM)
    # $text = $encodingOEM.GetString($bytes)
    # [System.IO.File]::WriteAllText($logPath, $text, [System.Text.Encoding]::UTF8)

    [System.Windows.Forms.MessageBox]::Show("End of backup. `nLog file: $logPath","OK",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information)
	
})

# === Ajouter tous les éléments à la fenêtre (sauf fichier log) ===
$form.Controls.AddRange(@($lblSrc, $txtSrc, $btnSrc, $lblDest, $txtDest, $btnDest, $lblLog, $txtLog, $btnLog, $btnRun))

# === Afficher ===
[void]$form.ShowDialog()
