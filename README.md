# automated-linode-failover-workshop
A way of setting up the linode-workshop lab in single operation by using Terraform.
Lab reference: https://github.com/akamai/linode-failover-workshop

#Requirements:

--> install terraform (this setup was made with Terraform v1.2.8)
https://www.terraform.io/downloads

Optional:

-->VisualStudio Code

# Instructions

1-Download the folder either through the UI or by pulling the git repository. Make sure the files are in an isolated folder, as it will be the Terraform working directory. If you list the files, you should see something similar as the following:


```
-rw-r--r--  1 jucot  staff  2575 Sep 11 17:57 labsetup.sh
-rw-r--r--  1 jucot  staff  1034 Sep 11 17:10 linode-failover-workshop.tf
drwxr-xr-x  4 jucot  staff   128 Aug 29 12:25 ssh-keys
-rw-r--r--  1 jucot  staff   103 Sep  4 20:37 terraform.tfvars
```

2-Move to that folder through the command line or by opening the folder on VS Code










