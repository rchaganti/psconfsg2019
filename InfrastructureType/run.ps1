$return = Get-InfrastructureType | ConvertTo-Json | Out-String
Out-File -Encoding Ascii -FilePath $res -inputObject $return
