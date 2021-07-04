# Generar las credenciales, este paso es solo para crear y actualizar las credenciales de administrador
# $Credential = Get-Credential

# Exportar la credenciales a una ruta local
# $Credential | Export-CliXml -Path "${env:\userprofile}\PowerBIFree.Cred"

# Si el archivo XML con la credenciales existe
$Credential = Import-CliXml -Path "${env:\userprofile}\PowerBIFree.Cred"

# Conectar al Azure AD con las credenciales exportadas
Connect-AzureAD -Credential $Credential

# Validar si existe usuario y eliminar
$UserToDelete = Get-AzureADUser -SearchString "testing@konectaperu.onmicrosoft.com"

if($null -eq $UserToDelete){
   write-host("Crear usuario")
}else {
    Remove-AzureADUser -ObjectId "testing@konectaperu.onmicrosoft.com"
}

# Crear usuario
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "T3sting++2019"

New-AzureADUser -DisplayName "Testing" -PasswordProfile $PasswordProfile -UserPrincipalName "testing@konectaperu.onmicrosoft.com" -AccountEnabled $true -MailNickName "testing" -JobTitle "Usuario" -Department "Operacion" -UsageLocation "PE" -UserType "Member"

# Agregar licencia Power BI Free
$license = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses

$license.SkuId = (Get-AzureADSubscribedSku | Where-Object -Property SkuPartNumber -Value "POWER_BI_STANDARD" -EQ).SkuID
$licenses.AddLicenses = $license

Set-AzureADUserLicense -ObjectId "testing@konectaperu.onmicrosoft.com" -AssignedLicenses $licenses

# Desconectar conecion de datos
Disconnect-AzureAD