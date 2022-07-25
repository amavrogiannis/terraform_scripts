#!bin/bash
apt update -y && apt upgrade -y
apt install -y git wget unzip
TER_VER=`curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'`
uname -a > arch.txt
echo << 
if grep -R "arch" arch.txt
then
	echo "true"
else
	echo "false"
fi
>> check.txt

if [./check.txt == "true"]
then
    wget https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip
    unzip terraform_${TER_VER}_linux_amd64.zip
fi


wget https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip
unzip terraform_${TER_VER}_linux_amd64.zip

mv terraform /usr/local/bin/