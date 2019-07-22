
function Create-BasicAuthHeader {
  Param(
    [Parameter(Mandatory=$true)]
    [string]$Name,
    [Parameter(Mandatory=$true)]
    [string]$PAT
)

  $Auth = '{0}:{1}' -f $Name, $PAT
  $Auth = [System.Text.Encoding]::UTF8.GetBytes($Auth)
  $Auth = [System.Convert]::ToBase64String($Auth)
  $Header = @{Authorization=("Basic {0}" -f $Auth)} 
  $Header
}


$SourceGroupName = 'UAT'
$DestinationGroupName = 'UAT'
$APIKey = 'bmrirmwupf4bqjy27sfy2ej627f5p26ehn3sxsxcjwp6dqe7lydq'
$APIKeyName = 'any'

$GetVariableGroup = Invoke-WebRequest https://dev.azure.com/osndxb-default/OSNEscalationManagement/_apis/distributedtask/variablegroups?groupName=$SourceGroupName'&'api-version=5.0-preview.1 -Headers (Create-BasicAuthHeader $APIKeyName $APIKey) -Method Get 

$GetVariableGroupObject = $GetVariableGroup.content | ConvertFrom-Json



 $Body = @{
        "variables" = $GetVariableGroupObject.value.variables 
        "type" = "Vsts"
        "name"= $DestinationGroupName
        "description"= "A test variable group"

    }


$jsonbody = $Body | convertto-json


$create = Invoke-WebRequest https://dev.azure.com/osndxb-default/OSN%20Dialer/_apis/distributedtask/variablegroups?api-version=5.0-preview.1 -Headers (Create-BasicAuthHeader $APIKeyName $APIKey) -Method POST -ContentType 'application/json' -Body $jsonbody 