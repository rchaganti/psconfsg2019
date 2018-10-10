$parameters = @{
    InfrastructureType = $req_query_infrastructureType
    UsageModel = $reg_query_usageModel
    DeploymentModel = $reg_query_deploymentModel
    HostNetwork = $reg_query_hostNetwork
    RdmaOption = $reg_query_rdmaOption
}

$return = Get-InfrastructureDeploymentTask @parameters | ConvertTo-Json | Out-String
Out-File -Encoding Ascii -FilePath $res -inputObject $return
