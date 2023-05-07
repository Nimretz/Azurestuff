#Import the AzureAD PowerShell module
#Import-Module AzureAD

# Run the Get-AzureADApplication cmdlet to retrieve a list of all Azure AD applications
Write-Host "Retrieving list of Azure AD applications..."
$applications = Get-AzureADApplication -All $true

# Create an empty array to store the output
$output = @()

# Loop through each application and retrieve the ReplyUrls, WwwHomePage, and HomePage properties
foreach ($application in $applications) {
    # Extract the object ID and display name from the current application
    $objectId = $application.ObjectId
    $displayName = $application.DisplayName
    
    Write-Host "Retrieving properties for $($displayName) ($($objectId))..."
    
    # Retrieve the application's properties
    $replyUrls = Get-AzureADApplicationProperty -ObjectId $objectId -PropertyDisplayName "Reply URL"
    $wwwHomePage = Get-AzureADApplicationProperty -ObjectId $objectId -PropertyDisplayName "Homepage URL"
    $homePage = Get-AzureADApplicationProperty -ObjectId $objectId -PropertyDisplayName "Home page URL"
    
    # If any of the properties are null, set them to "none"
    if ($replyUrls -eq $null) { $replyUrls = "none" }
    if ($wwwHomePage -eq $null) { $wwwHomePage = "none" }
    if ($homePage -eq $null) { $homePage = "none" }
    
    # Create a hashtable representing the current application's output
    $applicationOutput = @{
        "DisplayName" = $displayName
        "ObjectId" = $objectId
        "ReplyUrls" = $replyUrls
        "WwwHomePage" = $wwwHomePage
        "HomePage" = $homePage
    }
    
    # Add the hashtable to the output array
    $output += $applicationOutput
}

# Print the output to the console
$output | Format-Table DisplayName, ObjectId, ReplyUrls, WwwHomePage, HomePage

# Save the output to a file
$output | Export-Csv -Path "C:\output.csv" -NoTypeInformation

Write-host "Output saved to C:\output.csv."
