# Spark with Yarn deployment script

This project contains a simple set of scripts and configuration files to deploy yarn in a set of virtual machines

# Usage
First, make sure you have your virtual machines set up with ssh installed and with root access via RSA keys. Also, install java 8 or 11 manually (this is not done automatically because distributions such as debian 12 do not have openjdk of these versions by default)

After that, populate the ssh_hosts and hosts files. The first one should contain the externally accessible ip/hosts that you can directly execute `ssh root@<host>`, while the second are ip/hosts that can be accessed in the machines to locate each other (in the format expected by an /etc/hosts file).

**Note:** the machine that will act as master should have "master" in their hostname, and the workers should not have it.

Then, take a look at the hadoop and spark configuration files to match what you want.

Finally, you should be able to run `bash installer.sh`. Be careful because ah ssh password prompt might popup during the installation.

# Thanks
This would not be possible without the help from Henrique Gomes, so thanks for showing how hadoop/yarn is configured!
