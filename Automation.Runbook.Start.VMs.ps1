Workflow StartVMs {
    
  #Variabelen
  $SubscriptionId = "<SUBSCRIPTION ID>"
  $VMsResourceGroup = "<RESOURCE GROUP NAME OF VMS>"
  $AutomationAccount = "<AUTOMATION ACCOUNT NAME>"
  $AutomationAccountRG = "<RESROUCE GROUP NAME OF AUTOMATION ACCOUNT>"
  $VMsVariable = "<VARIABLE NAME THAT CONTAINS VMS>"

  # =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  # = DON'T CHANGE ANYTHING BELOW THIS LINE ! =
  # =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  # Login to Azure
  $connectionName = "AzureRunAsConnection"
  $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName
  Add-AzureRmAccount `
    -ServicePrincipal `
    -TenantId $servicePrincipalConnection.TenantId `
    -ApplicationId $servicePrincipalConnection.ApplicationId `
    -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint

  #Select the Azure Subscription
  Select-AzureRmSubscription -SubscriptionId $SubscriptionId

  # Compile lift with VM names from variable
  $vmvalues = Get-AzureRmAutomationVariable -Name $VMsVariable -ResourceGroupName $AutomationAccountRG -AutomationAccountName $AutomationAccount
  # Separated list based on semicolon
  $vms = $vmvalues.Value.Split(";")
    
  # Start VM's
  ForEach -Parallel ($vm in $vms) { 

    Start-AzureRmVM -Name $vm -ResourceGroupName $VMsResourceGroup
    Write-Output "VM $vm wordt ingeschakeld"
  
  }

}
