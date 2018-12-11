for az_sub in `az account list | egrep -v "^Name|-----" | awk '{print $5}'`
do
echo "subscription = "$az_sub
az account set --subscription $az_sub
az disk list --query '[?managedBy==`null`].[id]'|egrep -v "^Column1|--"|awk -F"/" '{print $9}'| sed 's/^/disk = /'
done
