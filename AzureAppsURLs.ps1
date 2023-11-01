#Import the AzureAD PowerShell module
#Import-Module AzureAD

# Run the Get-AzureADApplication cmdlet to retrieve a list of all Azure AD applications
Write-Host "[*] Retrieving list of Azure AD applications..."
$applications = Get-AzureADApplication -All $true

# Create an empty array to store the output
$output = @()

# Loop through each application and retrieve the ReplyUrls, WwwHomePage, and HomePage properties
foreach ($application in $applications) {
    # Extract the object ID and display name from the current application
    $objectId = $application.ObjectId
    $displayName = $application.DisplayName
    
    Write-Host "[+]Retrieving properties for $($displayName) ($($objectId))"
    
    # Retrieve the application's properties
    $properties = Get-AzureADApplication -ObjectId $objectId | Select-Object -Property ReplyUrls, WwwHomepage, Homepage   
    
    # Create a custom object with properties
    $customObject = [PSCustomObject]@{
        DisplayName = $displayName
        ObjectId = $objectId
        Properties = @{
            ReplyUrls = $properties.ReplyUrls
            WwwHomePage = $properties.WwwHomepage
            HomePage = $properties.HomePage
        }
    }
    
    # Add the custom object to the output array
    $output += $customObject
}

# Convert the output array to JSON
$jsonOutput = $output | ConvertTo-Json -Depth 4

$filePath = "C:\plzure.json"  # Update this with your desired file path

$jsonOutput | Set-Content -Path $filePath
Write-Host "[*] JSON data saved to $filePath"
