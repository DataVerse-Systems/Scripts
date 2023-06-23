# Script Name:                  Organizational Unit Generation
# Author:                       David Prutch
# Date of latest revision:      06/22/2023
# Purpose:                      Create Parent and Child Organizational Units for New company aquisitions within Globex Domain

# Run this Script In PowershellISE as administrator.
# Replace ParentOU with string name of Company to be added.
# Replace each Child name in $childName with the Department names forthe new company

# Declare Variables
# Set the domain name
$domain = "corp.globex.com"
# Parent OU 
$parentOUName = "ParentOU"
# Child OU name
$childOUName = @("ChildOU1","ChildOU2","ChildOU3","ChildOU4")
# Distinguished name  of parent OU
$parentOUDN = "OU=$parentOUName,DC=corp,DC=globex,DC=com"
# Distinguished name  of child OU
$childOUDN = "OU=$childOUName,$parentOUDN"

# Main
# Create parent OU
New-ADOrganizationalUnit -Name $parentOUName -Path "DC=corp,DC=globex,DC=com"

# Create child OUs
foreach ($child in $childOUName) {
    New-ADOrganizationalUnit -Name $childOUName -Path $parentOUDN
}

# Verify OUs are created successfully
$parentOU = Get-ADOrganizationalUnit -Filter { Name -eq $parentOUName }
$childOU = Get-ADOrganizationalUnit -Filter { Name -eq $childOUName }

if ($parentOU -ne $null) {
    Write-Host "Parent OU '$parentOUName' created successfully."
} else {
    Write-Host "Failed to create parent OU '$parentOUName'."
}

if ($childOU -ne $null) {
    Write-Host "Child OU '$childOUName' created successfully."
} else {
    Write-Host "Failed to create child OU '$childOUName'."
}
# End