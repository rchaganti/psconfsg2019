$parameters = @{
    InfrastructureType = $req_query_infrastructureType
    UsageModel = $re_query_usageModel
    DeploymentModel = $reg_query_deploymentModel
    HostNetwork = $reg_query_hostNetwork
}

$return = Get-InfrastructureHostNetworkRdmaOption @parameters | ConvertTo-Json | Out-String
Out-File -Encoding Ascii -FilePath $res -inputObject $return
