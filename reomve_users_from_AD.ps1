# Script Name:                  Remove multiple Users from Active Directory
# Author:                       David Prutch
# Date of latest revision:      06/23/2023
# Purpose:                      Remove a group of users from Active Directory (AD) from CSV file.

# Run this Script In PowershellISE as administrator.
# This script imports a .csv file, reads each line independently then removes the users.

# Main
# Path to CSV file
$csvPath = "C:\Users\Administrator\Documents\SunFlow_Org_Chart.csv.txt"

# Import CSV File
$users = Import-Csv -Path $csvPath

# Loop through users in CSV file and remove users in Active Directory (AD)
foreach ($user in $users) {
    $userName = $user.UserName
     # Check if the user exists
    if (Get-ADUser -Filter "SamAccountName -eq '$userName'") {
        # Remove the user
        Remove-ADUser -Identity $userName -Confirm:$false
        Write-Host "User '$userName' has been removed from Active Directory."
    } else {
        Write-Host "User '$userName' does not exist in Active Directory."
    }
}
#End