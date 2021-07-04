# Generar las credenciales, este paso es solo para crear y actualizar las credenciales de administrador
$Credential = Get-Credential

# Exportar la credenciales a una ruta local
$Credential | Export-CliXml -Path "${env:\userprofile}\PowerBIFree.Cred"

# Si el archivo XML con la credenciales existe
$Credential = Import-CliXml -Path "${env:\userprofile}\PowerBIFree.Cred"

# Conectar al Azure AD con las credenciales exportadas
Connect-AzureAD -Credential $Credential

Get-AzureADSubscribedSku

# Desconectar conecion de datos
Disconnect-AzureAD

#texto de cambio