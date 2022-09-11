#!/bin/bash
#General setup for the  user (ssh hardening)
useradd -m spaceU -s /bin/bash
echo -e "H57yUL8h\nH57yUL8h" | passwd spaceU #random password for spaceU, wont be required since login will be through key, and user will be able to sudo without password
mkdir /home/spaceU/.ssh
cp /root/.ssh/authorized_keys /home/spaceU/.ssh/authorized_keys
chmod 600 /home/spaceU/.ssh/authorized_keys
chmod 700 /home/spaceU/.ssh
chown -R spaceU:spaceU /home/spaceU/.ssh
echo $'#spaceU entry\nspaceU ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
sed -i '/^PermitRootLogin[ \t]\+\w\+$/{ s//PermitRootLogin no/g; }' /etc/ssh/sshd_config
systemctl restart sshd

#Git Install
apt-get update
apt-get install git -y
git init && git pull https://github.com/jcotoBan/linode-failover-workshop.git
chmod +x clean.sh

#Install terraform

apt-get update &&  apt-get install -y gnupg software-properties-common
apt-get install wget -y
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor |  tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" |  tee /etc/apt/sources.list.d/hashicorp.list
apt update &&  apt-get install terraform

#Terraform Setup

echo 'export TF_VAR_token="<Type your linode token here>"' >> .bashrc #Inserting your linode token as an env variable on remote host.
source .bashrc

terraform init

terraform plan \
 -var-file="terraform.tfvars"


 terraform apply -auto-approve \
 -var-file="terraform.tfvars"

#Kubernetes setup

apt-get update && apt-get install -y ca-certificates curl && curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" |  tee /etc/apt/sources.list.d/kubernetes.list
apt-get update && apt-get install -y kubectl

echo 'export KUBE_VAR="$(terraform output kubeconfig_1)"' >> .bashrc && source .bashrc && echo $KUBE_VAR | base64 -di > lke-cluster-config1.yaml

echo 'export KUBE_VAR="$(terraform output kubeconfig_2)"' >> .bashrc && source .bashrc && echo $KUBE_VAR | base64 -di > lke-cluster-config2.yaml

echo 'export KUBECONFIG=lke-cluster-config1.yaml:lke-cluster-config2.yaml' >> .bashrc

echo 'alias k=kubectl' >> .bashrc

source .bashrc


#Kubernetes deployment setup


IFS=$'\n' contexts=($(kubectl config get-contexts --output=name))

  for each in "${contexts[@]}"
   do
    kubectl config use-context $each
    kubectl apply -f deployment.yaml
    kubectl create secret tls mqtttest --cert cert.pem --key key.pem
    kubectl apply -f service.yaml
    sleep 5
   done
