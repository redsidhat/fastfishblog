# Prerequisites

* export AWS_SECRET_ACCESS_KEY=awssecretaccesskey
* export AWS_ACCESS_KEY_ID=awsaccesskeyid
* export ANSIBLE_HOST_KEY_CHECKING=False

##### Ansible and terraform are expected to installed in the environment where the script runs.

> The script parameter order has been changed to accomedate a new parameter, ssh_key

```sh
bash cloud-automation.sh test dev ubuntu_forerunners.pem 1