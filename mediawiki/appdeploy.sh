#!/bin/bash

#RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'

echo -e "${GREEN}Configuring kubectl for user: `whoami`${NC}"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo -e "${GREEN}Deploying mysql to cluster${NC}"
kubectl apply -f mysql-deployment.yaml
kubectl apply -f mysql-pv.yaml

echo -e "${GREEN}Configuring MySQL for necessary DB/USER/PASS${NC}"
kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -ppassword -e "CREATE DATABASE IF NOT EXISTS wikidb ; GRANT ALL ON *.* TO 'wiki'@'%' IDENTIFIED BY 'wiki@123';"

echo -e "${GREEN}Deploying MediaWiki to cluster${NC}"
## insert sed cmd to replace endpoint in LocalSetting.php
sed -i "s/\$wgServer = .*/\$wgServer = \"http:\/\/`curl ifconfig.io`:32191\";/g" LocalSettings.php
kubectl create configmap phpsetting --from-file LocalSettings.php
kubectl apply -f mediawiki-deployment.yaml
kubectl apply -f mediawiki-svc.yaml

echo -e "${GREEN} Access server over URL `curl ifconfig.io`:32191${NC}"
