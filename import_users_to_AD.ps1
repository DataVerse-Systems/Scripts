# Script Name:                  Import Users to Active Directory
# Author:                       David Prutch
# Date of latest revision:      06/21/2023
# Purpose:                      Create new user(s) in Active Directory (AD) from CSV file.

# Run this Script In PowershellISE as administrator.
# This script imports a .csv file, reads each line independently, checks the potential user against users in Active Directory.
# If the user already exists they are skipped and the script moves on to the next.
# If the user does not exist in Active Directory they are added to AD and moved to their Department Organizational Unit.

# Main
# Path to CSV file - replace <path to .csv file> with actual path to .csv file
$csvPath = <path to .csv file>

# Import CSV File
$users = Import-Csv -Path $csvPath

# Loop through users in CSV file and create users in Active Directory (AD)
foreach ($user in $users) {
    $firstName = $user.FirstName
    $lastName = $user.LastName
    $fullName = "$firstName $lastName"
    $userName = $user.UserName
    $title = $user.title
    $ou = $user.Department
    $password = 'Password123'

    # Check if User exists in AD
    if (Get-ADUser -Filter {SamAccountName -eq $userName}) {
        Write-Host "User '$userName' already exists in Active Directory. Skipping"
        continue
    }    

    # Create user in AD
    New-ADUser `
    -SamAccountName $userName `
    -GivenName $firstName `
    -Surname $lastName `
    -Name $fullName `
    -Email "$userName@corp.globex.com" `
    -Enabled $true `
    -AccountPassword (ConvertTo-SecureString -AsPlainText $password -Force) `
    -ChangePasswordAtLogon $true `
    | Move-ADObject -TargetPath "CN='$firstName $lastName',OU=$ou,OU=SunFlow,DC=corp,DC=globex,DC=com"
}
# End