<#
# CITRA IT - EXCELÊNCIA EM TI
# SCRIPT PARA LOCALIZAR A QUANTIDADE DE ATUALIZAÇÕES PENDENTES DO WINDOWS EM COMPUTADORES REMOTOS
# AUTOR: luciano@citrait.com.br
# DATA: 19/12/2020
# EXAMPLO DE USO: Powershell -ExecutionPolicy ByPass -File C:\scripts\PS_Remote_Check_WindowsUpdates.ps1 -Computers SERVER-AD01,SERVER-AD02,SERVER-FS01
#>

Param(
	[Parameter(Mandatory=$True)] [String[]] $Computers
)


$block_check_updates = {
	$SearchCriteria = "IsInstalled=0 And Type='Software' And IsHidden=0"
	$UpdateSession = New-Object -ComObject Microsoft.Update.Session
	$UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
	$SearchResult = $UpdateSearcher.Search($SearchCriteria)

	#New-Object PSObject -Property @{Servidor=$env:computername; AtualizacoesDisponiveis=$SearchResult.Updates.Count}
	Return $env:computername + "`t" + $SearchResult.Updates.Count
}

$ErrorActionPreference = "Stop"
Write-Host -ForegroundColor Yellow "Searching for updates"
Write-Host "Server`t`tUpdates"

$TimeOut = New-PSSessionOption -OpenTimeout 10000
Invoke-Command -ComputerName $Computers -ScriptBlock $block_check_updates -SessionOption $TimeOut

Write-Host "Script finished. Press any key to exit."
[Console]::ReadKey()
