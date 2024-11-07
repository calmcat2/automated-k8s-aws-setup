# Automated Kubernetes AWS Setup

This repository leverages GitHub Actions to automate the creation of a Kubernetes cluster (v1.31.0) on provisioned EC2 instances on AWS. All you need is an AWS account and a GitHub account. Additionally, a workflow is provided to delete the Kubernetes cluster as long as the Terraform state file is available.

## Prerequisites
1. AWS user credentials (Access key ID/Secret pair) with the necessary EC2 action rights. The minimum required permissions are detailed in the `aws_iam_policy.json`.
2. An SSH key (note the name) generated in AWS, with the private key saved in .pem format.
3. The ability to copy this repository and create your own repository (it is highly recommended to use a private repository as all artifacts are accessible by the public in a public repository).

## Steps to Create a Kubernetes Cluster
1. Save the following secrets for GitHub Actions in your repository. Visit [this link](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-a-repository) for instructions:
   - `AWS_ACCESS_KEY_ID`: Access key of the AWS user
   - `AWS_SECRET_ACCESS_KEY`: Secret key of the AWS user
   - `SSH_KEY_EC2`: The entire content of the SSH key .pem file
2. Go to the GitHub Actions tab, and on the left, choose the workflow `Create a k8s cluster`.
3. On the right side, click `Run workflow`, and enter the customization information:
   - Default AWS region to create all resources. Default is `us-east-1`.
   - Number of worker nodes to be provisioned. Default is `1`.
   - Machine type of the master node. Default is `t2.medium`.
   - Machine type of the worker node. Default is `t2.medium`.
   - Name of the SSH key on AWS to be used to access the EC2 instances.
4. Click `Run workflow`.
5. Once the workflow completes successfully, download the artifact `kubeconfig` to access the Kubernetes cluster.

## Steps to Destroy a Kubernetes Cluster
We use the workflow `Delete a k8s cluster` to destroy a Kubernetes cluster. There are two options to use this workflow:

### Option 1: Use the Run ID of a Creation Workflow
**Note**: Artifacts are saved in GitHub for up to 90 days. If it has been more than 90 days since the workflow was run, this method will not work.

1. Create a personal access token:
   - Go to GitHub Settings:
     - Navigate to your GitHub profile and click on your profile picture in the top-right corner.
     - Select "Settings" from the dropdown menu.
   - Access Developer Settings:
     - In the left sidebar, click on "Developer settings".
   - Generate a New Token:
     - Click on "Personal access tokens".
     - Click on "Generate new token".
   - Configure Token Permissions:
     - **Note**: Give your token a descriptive name.
     - **Expiration**: Set an expiration date for the token.
     - **Repository access**: Only select repositories -> Our repository 
     - **Permissions**: Select the following scopes:
       - `Actions`: Read-only
       - `Secrets`: Read-only
     - Click "Generate token".
2. Copy the Token:
   - Copy the generated token. **Note**: You will not be able to see this token again, so make sure to copy it now.
3. Save the token as a secret in your repository with the name `PERSONAL_ACCESS_TOKEN`.
4. Start the workflow and enter the run ID of the workflow that exported the artifact `terraform_state_files2`.

### Option 2: Use the Downloaded Terraform State File
1. Download the artifact `terraform_state_files2` after a successful run of the workflow `Create a k8s cluster`. Check [this link](https://docs.github.com/en/actions/managing-workflow-runs-and-deployments/managing-workflow-runs/downloading-workflow-artifacts) for instructions.
2. Add the file to the local repository, under the directory `automated-k8s-aws-setup/Terraform3`. Then push the changes.
3. Run the workflow `Delete a k8s cluster`.
