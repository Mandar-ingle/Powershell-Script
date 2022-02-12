using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$name = $Request.Query.Name
if (-not $name) {
    $name = $Request.Body.Name
}

$body = "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."
$SubscriptionId = '607c28a6-9894-4139-8bd3-0ea1cad2a6e1';
$RecurrencePeriodStart = '2022-01-25T00:00:00Z';
$RecurrencePeriodEnd = '2022-12-25T00:00:00Z';
$DestinationStorageAccountId = '/subscriptions/' + $SubscriptionId + '/resourceGroups/rg_ACM/providers/Microsoft.Storage/storageAccounts/stacmdata0002'; 
$ReportsStorageContainer  = 'exportmonthlynew';
$ContainerFolderName = 'exportnew';

# Create or Update Azure Cost Management Export / https://docs.microsoft.com/en-us/rest/api/cost-management/query/usage#timeframetype
$Params = @{
    Name                      = 'ACMCostManagementMonthly' 
    DefinitionType            = 'Usage'
    Scope                     = 'subscriptions/' + $SubscriptionId
    DestinationResourceId     = $DestinationStorageAccountId
    DestinationContainer      = $ReportsStorageContainer
    DefinitionTimeframe       = 'TheLastMonth'
    ScheduleRecurrence        = 'Monthly'
    RecurrencePeriodFrom      = $RecurrencePeriodStart
    RecurrencePeriodTo        = $RecurrencePeriodEnd
    ScheduleStatus            = 'Active'
    DestinationRootFolderPath = $ContainerFolderName
    Format                    = 'Csv'
    DatasetGranularity        = 'Daily'
}

#New-AzCostManagementExport -Scope "subscriptions/607c28a6-9894-4139-8bd3-0ea1cad2a6e1" -Name "CostManagementMonthly" -ScheduleStatus "Active" -ScheduleRecurrence "Monthly" -RecurrencePeriodFrom "2022-01-21T00:00:00Z" -RecurrencePeriodTo "2022-07-21T00:00:00Z" -Format "Csv" -DestinationResourceId "/subscriptions/607c28a6-9894-4139-8bd3-0ea1cad2a6e1/resourceGroups/rg_ACM/providers/Microsoft.Storage/storageAccounts/stacmdata0002" `  -DestinationContainer "exportmonthlyfinal" -DestinationRootFolderPath "ad-hoc" -DefinitionType "Usage" -DefinitionTimeframe "MonthToDate" -DatasetGranularity "Daily"

New-AzCostManagementExport @Params

if ($name) {
    $body = "Hello, $name. This HTTP triggered function executed successfully."
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
