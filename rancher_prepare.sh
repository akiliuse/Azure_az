#!/bin/bash -e

function install_rancher() {
  local tags=$1
  local VMname=$tags-rancher
  local ip=$(az vm show -d -g $tags -n $VMname --query publicIps -o tsv)

  ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no az-user@$ip \
  'sudo docker run -d --restart=unless-stopped -p 80:80 -p 443:443 --privileged rancher/rancher:latest'
  container=`ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no az-user@$ip 'sudo docker ps -q'`
  sleep 60
  ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no az-user@$ip "sudo docker logs $container 2>&1 | grep Password"

}

install_rancher $1
