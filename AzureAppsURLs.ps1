# Import the AzureAD PowerShell module
# Import-Module AzureAD

# Step 1: Retrieve Azure AD Applications
Write-Host "[*] Retrieving list of Azure AD applications..."
$applications = Get-AzureADApplication -All $true

# Step 2: Create an empty array to store the output
$outputApplications = @()

# Step 3: Loop through Azure AD applications
foreach ($application in $applications) {
    $objectId = $application.ObjectId
    $displayName = $application.DisplayName

    Write-Host "[+] Retrieving properties for Azure AD Application: $($displayName) ($($objectId))"

    # Retrieve properties
    $properties = Get-AzureADApplication -ObjectId $objectId | Select-Object -Property ReplyUrls, WwwHomepage, Homepage

    # Create a custom object
    $customObject = [PSCustomObject]@{
        DisplayName = $displayName
        ObjectId = $objectId
        Type = "AzureADApplication"
        Properties = @{
            ReplyUrls = $properties.ReplyUrls
            WwwHomePage = $properties.WwwHomepage
            HomePage = $properties.Homepage
        }
    }

    # Add the custom object to the output array
    $outputApplications += $customObject
}

# Step 4: Retrieve Enterprise Applications (Service Principals)
Write-Host "[*] Retrieving list of Enterprise Applications..."
$enterpriseApps = Get-AzureADServicePrincipal -All $true

# Step 5: Create an empty array to store the output for enterprise apps
$outputEnterpriseApps = @()

# Step 6: Loop through Enterprise Applications
foreach ($enterpriseApp in $enterpriseApps) {
    $objectId = $enterpriseApp.ObjectId
    $displayName = $enterpriseApp.DisplayName

    Write-Host "[+] Retrieving properties for Enterprise Application: $($displayName) ($($objectId))"

    # Create a custom object for Enterprise Applications
    $customObject = [PSCustomObject]@{
        DisplayName = $displayName
        ObjectId = $objectId
        Type = "EnterpriseApplication"
        Properties = @{
            Homepage = $enterpriseApp.Homepage
            ReplyUrls = $enterpriseApp.ReplyUrls
            ErrorURL = $enterpriseApp.ErrorUrl
            LogoutURL = $enterpriseApp.LogoutUrl
            SamlMetadataUrl = $enterpriseApp.SamlMetadataUrl
        }
    }

    # Add the custom object to the enterprise output array
    $outputEnterpriseApps += $customObject
}

# Step 7: Combine both arrays
$output = $outputApplications + $outputEnterpriseApps

# Step 8: Convert to JSON and save to file
$jsonOutput = $output | ConvertTo-Json -Depth 4

$filePath = "C:\plzure.json"  # Update this with your desired file path
$jsonOutput | Set-Content -Path $filePath

Write-Host "[*] JSON data saved to $filePath"
