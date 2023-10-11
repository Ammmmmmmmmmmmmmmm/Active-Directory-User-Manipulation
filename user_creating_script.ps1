#RUN SCRIPT AS ADMINISTRATOR AND MAKE SURE ACCOUNT HAS DOMAIN ADMIN PRIVELEDGES
#create log file of all commands for error handling
Set-Location -Path "C:\Users\a-meave\Desktop\Active_Directory_User_Creation"
Start-Transcript -Path ".\user_creating_script_log.log" -Append


#Load in the csv file for employees
#Creates an array of hash tables, change the csv categories to headers appropriate for acitve directory
$csv_data = Import-Csv -Path ".\userlist.csv" -Delimiter "," | Select-Object -Property `
@{Name="EmployeeID";Expression={$_.id}},
@{Name="GivenName";Expression={$_.firstname}},
@{Name="SurName";Expression={$_.lastname}},
@{Name="Title";Expression={$_.role}},
@{Name="City";Expression={$_.location}}


#Create organizational unit and security group if not already in existance
if (-not (Get-ADOrganizationalUnit -Filter {Name -eq "_HOUSTON_"})){
New-ADOrganizationalUnit -Name _HOUSTON_ -ProtectedFromAccidentalDeletion $false
}
if (-not (Get-ADOrganizationalUnit -Filter {Name -eq "_DALLAS_"})){
New-ADOrganizationalUnit -Name _DALLAS_ -ProtectedFromAccidentalDeletion $false
}
if (-not (Get-ADOrganizationalUnit -Filter {Name -eq "_SAN_ANTONIO_"})){
New-ADOrganizationalUnit -Name _SAN_ANTONIO_ -ProtectedFromAccidentalDeletion $false
}
if (-not (Get-ADOrganizationalUnit -Filter {Name -eq "_AUSTIN_"})){
New-ADOrganizationalUnit -Name _AUSTIN_ -ProtectedFromAccidentalDeletion $false
}
if (-not (Get-ADGroup -Filter {Name -eq "TexanPermissions"})){
New-ADGroup -Name "TexanPermissions" -GroupScope Global -GroupCategory Security
}
if (-not (Get-ADGroup -Filter {Name -eq "PowerUser"})){
New-ADGroup -Name "PowerUser" -GroupScope Global -GroupCategory Security
}


#Parse csv hashes
foreach ($row in $csv_data) {


    $commonName = "$($row.GivenName) $($row.SurName)"
    $username = $commonName
    if ($row.City -like "Houston"){
        $CityOU = "ou=_HOUSTON_,$(([ADSI]`"").distinguishedName)"
    }
    if ($row.City -like "San Antonio"){
        $CityOU = "ou=_SAN_ANTONIO_,$(([ADSI]`"").distinguishedName)"
    }
    if ($row.City -like "Dallas"){
        $CityOU = "ou=_DALLAS_,$(([ADSI]`"").distinguishedName)"
    }
    if ($row.City -like "Austin"){
        $CityOU = "ou=_AUSTIN_,$(([ADSI]`"").distinguishedName)"
    }
    #If user has same name as another append employeeID to username
    if (Get-ADUser -Filter {Name -eq $commonName}) {
        $username = "$($commonName) $($row.EmployeeID)"
    }
    $intEmployeeID = [int]$row.EmployeeID

    #If employee already in active directory output error
    if ((Get-ADUser -Filter {EmployeeID -eq $IntEmployeeID} -Properties EmployeeID )){
        Write-Host "User '$commonName' creation failed, account already in use" -BackgroundColor Black -ForegroundColor Yellow


    }else{
        #Place users into _Users_ orginizational unit and give security group
        try{
        New-ADUser `
            -SamAccountName $username `
            -AccountPassword (ConvertTo-SecureString "Password1" -AsPlainText -Force) `
            -DisplayName $username `
            -Name $commonName `
            -GivenName $row.GivenName `
            -SurName $row.SurName `
            -EmployeeID $row.EmployeeID `
            -Title $row.Title `
            -City $row.City `
            -State "Texas" `
            -Path $CityOU `
            -Enabled $true `
            -ChangePasswordAtLogon $true `
            -ErrorAction Stop
            

        Add-ADGroupMember -Identity "TexanPermissions" -Members $username
        if ($row.Title -like "*Lead Engineer*"){
        Add-ADGroupMember -Identity "PowerUser" -Members $username
        }
        Write-Host "User '$commonName' created successfully." -BackgroundColor Black -ForegroundColor Green


        } Catch {
        Write-Host "User '$commonName' creation failed: $($_.Exception.Message)" -BackgroundColor Black -ForegroundColor Red
    }
    }
    
}
Stop-Transcript  


