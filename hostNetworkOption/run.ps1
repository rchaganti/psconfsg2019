$parameters = @{
    InfrastructureType = $req_query_infrastructureType
    UsageModel = $reg_query_usageModel
    DeploymentModel = $reg_query_deploymentModel
}

$return = Get-InfrastructureHostNetworkOption @parameters | ConvertTo-Json | Out-String
Out-File -Encoding Ascii -FilePath $res -inputObject $return
