reggrp=prod_rg
az account set --subscription "subscriptionID"
az snapshot create -g $resgrp -n dev_sda_HOSTNAME_snapshot26Nov2018 --source dev_sda-HOSTNAME
az snapshot create -g $resgrp -n dev_sdb_HOSTNAME_snapshot26Nov2018 --source dev_sdb-HOSTNAME
az snapshot create -g $resgrp -n dev_sdc_HOSTNAME_snapshot26Nov2018 --source dev_sdc-HOSTNAME
az snapshot create -g $resgrp -n dev_sdd_HOSTNAME_snapshot26Nov2018 --source dev_sdd-HOSTNAME
az snapshot create -g $resgrp -n dev_sde_HOSTNAME_snapshot26Nov2018 --source dev_sde-HOSTNAME
