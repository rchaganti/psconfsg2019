$parameters = @{
    InfrastructureType = $req_query_infrastructureType
}

$return = Get-InfrastructureUsageModel @parameters | ConvertTo-Json | Out-String
Out-File -Encoding Ascii -FilePath $res -inputObject $return
