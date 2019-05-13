# convert-vhd -Path C:\Users\packer\AppData\Local\Temp\packerhv238285888\WindowsServer2019Docker.vhdx -DestinationPath C:\Users\packer\Desktop\Win2019Docker.vhd -VHDType Fixed

# Install-Module -Name AzureRM
Import-Module AzureRM
# Connect to Azure with an interactive dialog for sign-in
# Connect-AzureRmAccount
# Select-AzureRmSubscription -Subscription "Microsoft Azure Sponsorship"

$resourceGroup = 'chocolateyfest-docker-workshop-images'
$location = 'WestUS2'
# New-AzureRmResourceGroup -Name $resourceGroup -Location $location

$storageaccount = 'chocolateyfestsa'
$storageType = 'Standard_LRS'
$containername = 'vhds'
New-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccount -Location $location `
                  -SkuName $storageType -Kind "Storage"
$vhdName = 'windows_2019_docker_azure.vhd'
$urlOfUploadedImageVhd = ('https://' + $storageaccount + '.blob.core.windows.net/' + $containername + '/' + $vhdName)
Add-AzureRmVhd -ResourceGroupName $resourceGroup -Destination $urlOfUploadedImageVhd `
                  -LocalFilePath 'D:\work\output-hyperv-iso\Virtual Hard Disks\WindowsServer2019Docker.vhd'

$imageName="windows_2019_docker_17763"
$imageConfig = New-AzureRmImageConfig -Location $location
$imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType Windows -OsState Generalized `
                  -BlobUri $urlOfUploadedImageVhd
$image = New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroup -Image $imageConfig


# $diskSizeGB = '128'
# $subnetName = 'mySubnet'
# $vnetName = 'myVnet'
# $ipName = 'myPip'
# $nicName = 'myNic'
# $nsgName = 'myNsg'
# $ruleName = 'myRdpRule'
# $computerName = 'myComputerName'
# $vmName = 'myVM'
# $vmSize = 'Standard_D4_v3'
# $cred = Get-Credential
# $singleSubnet = New-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix 10.0.0.0/24
# $vnet = New-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroup -Location $location `
#                  -AddressPrefix 10.0.0.0/16 -Subnet $singleSubnet
# $pip = New-AzureRmPublicIpAddress -Name $ipName -ResourceGroupName $resourceGroup -Location $location `
#                  -AllocationMethod Dynamic
# $rdpRule = New-AzureRmNetworkSecurityRuleConfig -Name $ruleName -Description 'Allow RDP' -Access Allow `
#                  -Protocol Tcp -Direction Inbound -Priority 110 -SourceAddressPrefix Internet -SourcePortRange * `
#                  -DestinationAddressPrefix * -DestinationPortRange 3389
# $nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $resourceGroup -Location $location `
#                  -Name $nsgName -SecurityRules $rdpRule
# $nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $resourceGroup -Location $location `
#                  -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id
# $vnet = Get-AzureRmVirtualNetwork -ResourceGroupName $resourceGroup -Name $vnetName
# $vm = New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize
# Set the VM image as source image for the new VM
# $vm = Set-AzureRmVMSourceImage -VM $vm -Id $image.Id
# Finish the VM configuration and add the NIC.
# $vm = Set-AzureRmVMOSDisk -VM $vm  -DiskSizeInGB $diskSizeGB -CreateOption FromImage -Caching ReadWrite
# $vm = Set-AzureRmVMOperatingSystem -VM $vm -Windows -ComputerName $computerName -Credential $cred `
#                  -ProvisionVMAgent -EnableAutoUpdate
# $vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id
# Create the VM
# New-AzureRmVM -VM $vm -ResourceGroupName $resourceGroup -Location $location
# $vm = Set-AzureRmVMOperatingSystem -VM $vm -Windows -ComputerName $computerName -Credential $cred `
#                  -ProvisionVMAgent -EnableAutoUpdate
# $vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id
# Create the VM
# New-AzureRmVM -VM $vm -ResourceGroupName $resourceGroup -Location $location
