[CmdletBinding()] 
param() 
 
Trace-VstsEnteringInvocation $MyInvocation 
try { 
    
    
    # Get inputs. 
    $APIKey = Get-VstsInput -Name 'APIKey' -Require 
    $APIKeyName = Get-VstsInput -Name 'APIKeyName' -Require 
    $SourceProjectName = Get-VstsInput -Name 'SourceProjectName' -Require 
    $SourceGroupName = Get-VstsInput -Name 'SourceGroupName' -Require 
    $DestinationProjectName =  Get-VstsInput -Name 'DestinationProjectName' -Require 
    $DestinationGroupName = Get-VstsInput -Name 'DestinationGroupName' -Require 
    $Organization =  env:SYSTEM_TASKDEFINITIONSURI
    

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
  
   


$GetVariableGroup = Invoke-WebRequest $Organization + $SourceProjectName/_apis/distributedtask/variablegroups?groupName=$SourceGroupName'&'api-version=5.0-preview.1 -Headers (Create-BasicAuthHeader $APIKeyName $APIKey) -Method Get 

$GetVariableGroupObject = $GetVariableGroup.content | ConvertFrom-Json



 $Body = @{
        "variables" = $GetVariableGroupObject.value.variables 
        "type" = "Vsts"
        "name"= $DestinationGroupName
        "description"= ""

    }


$jsonbody = $Body | convertto-json


$create = Invoke-WebRequest $Organization + $DestinationProjectName/_apis/distributedtask/variablegroups?api-version=5.0-preview.1 -Headers (Create-BasicAuthHeader $APIKeyName $APIKey) -Method POST -ContentType 'application/json' -Body $jsonbody 

Write-Host $create



} finally { 
    Trace-VstsLeavingInvocation $MyInvocation 
}