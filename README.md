# automated-k8s-aws-setup
This repo leverages the power of github actions to automated the process create a kubernetes cluster (v1.31.0) on own provisioned EC2 instances on AWS. Another workflow is provided to delete the kubenetes cluster as long as the terraform state file is provided. 

### Pre-requisites
1. An AWS user credentials that has necessary EC2 action rights. The minimum rights are in the ```aws_iam_policy.json```.
2. An ssh key named "ansible" generated in AWS and a saved ssh private key in .pem.
3. Able to copy this repo and create your own repo (it's highly recommended using private repo as all artifacts are accessible by public in a public repo).

### Steps To Generate a k8s Cluster
1. Save the following secrets for github actions in your repo. Visit [here](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-a-repository) for instructions. 
   -  ```AWS_ACCESS_KEY_ID```: Access key of the AWS user
   -  ```AWS_SECRET_ACCESS_KEY```: Secret key of the AWS user
   -  ```SSH_KEY_EC2```: The whole content of the ssh key .pem file. 
2. Go to github actions 