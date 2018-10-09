# Supported query parameters:
  # tag

# Create an empty list to append results into
$return = Get-InfrastructureType | Out-String
Out-File -Encoding Ascii -FilePath $res -inputObject $return