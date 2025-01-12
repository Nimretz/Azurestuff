#install-module AzureAD
$results = Get-AzureADUser -All $true | ForEach-Object { Write-Host "Processing user: $($_.UserPrincipalName)" -ForegroundColor Yellow; $devices = Get-AzureADUserRegisteredDevice -ObjectId $_.ObjectId -All $true; if ($devices) { $devices | ForEach-Object { Write-Host "  Found device: $($_.DisplayName)" -ForegroundColor Green; [PSCustomObject]@{ UserPrincipalName = $_.UserPrincipalName; DeviceName = $_.DisplayName } } } else { Write-Host "  No devices found for user: $($_.UserPrincipalName)" -ForegroundColor Red; [PSCustomObject]@{ UserPrincipalName = $_.UserPrincipalName; DeviceName = "No devices found" } } } | Format-Table -AutoSize; $results | Export-Csv -Path "Users_And_Devices.csv" -NoTypeInformation -Encoding UTF8; Write-Host "Processing completed. Results saved to Users_And_Devices.csv." -ForegroundColor Cyan