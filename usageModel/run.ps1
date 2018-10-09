# Supported query parameters:
  # tag

# Create an empty list to append results into
$return = Get-InfrastructureUsageModel -InfrastructureType $req_query_infrastructureType | ConvertTo-Json | Out-String
Out-File -Encoding Ascii -FilePath $res -inputObject $return