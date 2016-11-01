#!/bin/bash
#getting parameter values and checking them

app=$1
if [ -z $1 ]; then
    echo "App name parameter missing"
    sleep 2
    exit 2
fi

run_env=$2
if [ -z $2 ]; then
    echo "Env name parameter missing"
    sleep 2
    exit 2
fi

ssh_key=$3
if [ -z $3 ]; then
    echo "ssh private-key is not provided. Taking ~/.ssh/id_rsa"
    sleep 1
    ssh_key='~/.ssh/id_rsa'
fi

server_count=$4
if [ -z $3 ]; then
    echo "Number of server is not specified. Taking deafult 2."
    sleep 1
    server_count=2
fi

server_size=$5
if [ -z $4 ]; then
    echo "Server size is not specified. Taking  t1.micro as deafult "
    sleep 1
    server_size='t1.micro'
fi

echo "Launching the servers in ec2..."
which terraform >/dev/null
if [ $? -ne 0 ]; then
	echo "Terraform is not present. Expecting terrafom in the \$PATH. Install terraform and proceed."
	sleep 2
	exit 2
fi
echo "Terraform is present..."
which ansible >/dev/null
if [ $? -ne 0 ]; then
	echo "Ansible is not present. Expecting Ansible in the \$PATH. Install Ansible and proceed."
	sleep 2
	exit 2
fi
echo "Ansible is present..."
echo "Proceeding to launching $server_count server(s)"
ssh_key=$(echo $ssh_key | sed -e 's/\.pem$//g')

sed -i "s/\s.*key_name\s=.*/    key_name = \"$ssh_key\"/g" terraform/fastfish.tf
sed -i "s/\s.*count\s=.*/    count = $server_count/g" terraform/fastfish.tf
sed -i "s/\s.*instance_type\s=.*/    instance_type = \"$server_size\"/g" terraform/fastfish.tf
cd terraform/
terraform plan
if [ $? -ne 0 ]; then
	echo "Terraform plan failed. Exiting"
	sleep 2
	exit 2
fi
echo "Proceeding with the above plan in 5 sec. Press ctrl + c to cancel"
sleep 5
terraform apply
if [ $? -ne 0 ]; then
	echo "Terraform apply failed. Exiting"
	sleep 2
	exit 2
fi
terraform output | grep -vE "\[|\]"|sed -e 's/,//g' > ../ansible/ansible-playbook/hosts
cd ../ansible/ansible-playbook
ansible-playbook -i hosts -u ubuntu --private-key $ssh_key.pem docker.yml
echo "IP of the servers are :"
cat hosts