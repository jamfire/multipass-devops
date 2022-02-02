# Multipass + Cloud Config DevOps

These are cloud configuration files for production ready apps. Mount or clone this repo to your Ubuntu virtual machine and then run the following command to install a production ready app to your instance. These scripts are built around Multipass inparticular but can be deployed to and cloud-based ubuntu server.

## Security Notice

These cloud init files add a passwords file under ```/home/ubuntu/.keyfile```. Please save these passwords somewhere safe and then delete the file from your server. You should also update the ```ssh_authorized_keys``` variable under ```users``` for scripts you use or you will be giving me access to your servers. My public key is there as an example.

## Pass Configuration during VM Creation

Ideally, you pass these cloud-init scripts during creatin of the VM. You need to update variables that are set in the ```runcmd``` module of the script you use. For example, using multipass you would run the following script to setup a WordPress server:

```bash
multipass launch --name wordpress --cloud-init wp-cloud-init.yml
```

This would create an Ubuntu instance with the host name ```wordpress``` installed with all of the features you need for production ready WordPress under Nginx, MariaDB, and Redis. And cloud-config-le files add support for LetsEncrypt. Otherwise, a self generated certificate is generated that you will need to replace with a certificate from a trusted authority or use a tool like mkcert to generate your own local certificates for local development purposes.

## After VM Creation

Mount this folder to your VM or clone the repository and run configuration from the commandline.

```bash
multipass mount ../cloud-devops wordpress:/home/ubuntu/cloud-devops
```

SSH into your VM and use ```cloud-init``` to install your system. You will need to update your public ssh_authorized_key under ```users``` and change your username if you would like. The following commands assume a clean install of ubuntu where no other cloud configurations have been applied.

```bash
ssh developer@192.168.64.1

sudo cloud-init clean
sudo cloud-init -f ./devops/wp-cloud-config.yml init
sudo cloud-init -f ./devops/wp-cloud-config.yml modules
sudo cloud-init -f ./devops/wp-cloud-config.yml modules -m final
```

## Multipass Domain Mapping

A ```multipass-hosts.sh``` bash script has been included with this repository. Running this script will automatically update your ```/etc/hosts``` file with your multipass vm's. The script will take the hostname and ip of each of your running multipass vm's and add them to the end of your hosts file.