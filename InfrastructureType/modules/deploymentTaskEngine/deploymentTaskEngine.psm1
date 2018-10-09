function Get-InfrastructureType
{
    [CmdletBinding()]
    param 
    (
        [Parameter()]
        [String]
        $Name
    )

    $dataPath = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent) -ChildPath 'data'
    $infrastructure = Get-Content -Path "${dataPath}\infrastructure.json" -Raw | ConvertFrom-Json
    if ($Name)
    {
        return $infrastructure.infrastructureType.Where({$_.Name -eq $Name})
    }
    else
    {
        return $infrastructure.infrastructureType    
    }
}

function Get-InfrastructureUsageModel
{
    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory = $true)]
        [String]
        $InfrastructureType,

        [Parameter()]
        [String]
        $Name
    )

    $infrastructure = Get-InfrastructureType -Name $infrastructureType
    if ($Name)
    {
        return $infrastructure.usageModel.Where({$_.Name -eq $Name})
    }
    else
    {
        return $infrastructure.usageModel
    }
    
}

function Get-InfrastructureDeploymentModel
{
    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory = $true)]
        [String]
        $InfrastructureType,

        [Parameter(Mandatory = $true)]
        [String]
        $UsageModel,
        
        [Parameter()]
        [String]
        $Name
    )
    
    $dataPath = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent) -ChildPath 'data'
    $usageModelObject = Get-InfrastructureUsageModel -InfrastructureType $InfrastructureType -Name $UsageModel
    $deploymentModel = Get-Content -Path "${dataPath}\$($usageModelObject.id).json" -Raw | ConvertFrom-Json

    if ($Name)
    {
        return $deploymentModel.deploymentModel.Where({$_.Name -eq $Name})
    }
    else
    {
        return $deploymentModel.deploymentModel
    }
}

function Get-InfrastructureHostNetworkOption
{
    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory = $true)]
        [String]
        $InfrastructureType,

        [Parameter(Mandatory = $true)]
        [String]
        $UsageModel,

        [Parameter(Mandatory = $true)]
        [String]
        $DeploymentModel,

        [Parameter()]
        [String]
        $Name
    )
    
    $dataPath = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent) -ChildPath 'data'
    $deploymentModelObject = Get-InfrastructureDeploymentModel -InfrastructureType $InfrastructureType -UsageModel $UsageModel -Name $DeploymentModel
    
    $hostNetworkObject = Get-Content -Path "${dataPath}\$($deploymentModelObject.Id).json" -Raw | ConvertFrom-Json 
    
    if ($Name)
    {
        return $hostNetworkObject.hostNetwork.Where({$_.Name -eq $Name})
    }
    else
    {
        return $hostNetworkObject.hostNetwork    
    }
}

function Get-InfrastructureHostNetworkRdmaOption
{
    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory = $true)]
        [String]
        $InfrastructureType,

        [Parameter(Mandatory = $true)]
        [String]
        $UsageModel,

        [Parameter(Mandatory = $true)]
        [String]
        $DeploymentModel,

        [Parameter(Mandatory = $true)]
        [String]
        $HostNetwork,

        [Parameter()]
        [String]
        $Name

    )
    
    $dataPath = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent) -ChildPath 'data'
    $hostNetworkOption = Get-InfrastructureHostNetworkOption -InfrastructureType $InfrastructureType -UsageModel $UsageModel -DeploymentModel $DeploymentModel -Name $HostNetwork 
    $rdmaOption = Get-Content -Path "${dataPath}\$($hostNetworkOption.Id).json" -Raw | ConvertFrom-Json

    if ($Name)
    {
        return $rdmaOption.rdma.Where({$_.Name -eq $Name})
    }
    else
    {
        return $rdmaOption.rdma
    }
}

function Get-InfrastructureDeploymentTask
{
    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory = $true)]
        [String]
        $InfrastructureType,

        [Parameter(Mandatory = $true)]
        [String]
        $UsageModel,

        [Parameter(Mandatory = $true)]
        [String]
        $DeploymentModel,

        [Parameter(Mandatory = $true)]
        [String]
        $HostNetwork,

        [Parameter(Mandatory = $true)]
        [String]
        $RdmaOption

    )
    
    $dataPath = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent) -ChildPath 'data'
    $rdmaOptionObject = Get-InfrastructureHostNetworkRdmaOption -InfrastructureType $InfrastructureType -UsageModel $UsageModel -DeploymentModel $DeploymentModel -HostNetwork $HostNetwork -Name $RdmaOption

    $deploymentTaskObject = Get-Content -Path "${dataPath}\$($rdmaOptionObject.Id).json" -Raw | ConvertFrom-Json

    return $deploymentTaskObject.deploymentTasks
}

function Get-InfrastructureDeploymentScript
{
    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory = $true)]
        [String]
        $InfrastructureType,

        [Parameter(Mandatory = $true)]
        [String]
        $UsageModel,

        [Parameter(Mandatory = $true)]
        [String]
        $DeploymentModel,

        [Parameter(Mandatory = $true)]
        [String]
        $HostNetwork,

        [Parameter(Mandatory = $true)]
        [String]
        $RdmaOption

    )
    
    $dataPath = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent) -ChildPath 'data'
    $rdmaOptionObject = Get-InfrastructureHostNetworkRdmaOption -InfrastructureType $InfrastructureType -UsageModel $UsageModel -DeploymentModel $DeploymentModel -HostNetwork $HostNetwork -Name $RdmaOption

    $deploymentTaskObject = Get-Content -Path "${dataPath}\$($rdmaOptionObject.Id).json" -Raw | ConvertFrom-Json

    $deploymentTasks = $deploymentTaskObject.deploymentTasks
    $deploymentScripts = @()
    $deploymentTaskDefinition = Get-Content -Path "${dataPath}\deploymentTasks.json" -Raw | ConvertFrom-Json

    foreach ($task in $deploymentTasks)
    {
        $taskDefinition = $deploymentTaskDefinition.tasks.Where({$_.Id -eq $task.Id})
        $taskDefinition | Add-Member -Name 'runOn' -Value $task.runOn -MemberType NoteProperty
        $taskDefinition | Add-Member -Name 'dependsOn' -Value $task.dependsOn -MemberType NoteProperty
        $deploymentScripts += $taskDefinition
    }

    return $deploymentScripts
}

Export-ModuleMember -Function *
