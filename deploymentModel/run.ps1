$parameters = @{
    InfrastructureType = $req_query_infrastructureType
    UsageModel = $reg_query_usageModel
}

$return = Get-InfrastructureDeploymentModel @parameters | ConvertTo-Json | Out-String
Out-File -Encoding Ascii -FilePath $res -inputObject $return
