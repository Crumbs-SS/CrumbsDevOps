# Cloud Formation Documentation

## Secrets Manager
- Create a secret for the domain of the image url that will be used for the container.
- The Secret Name and Key Name should both be 'image-url'
- The Value of the image-url should look like below:
    - ```ACCCOUNTID.dkr.ecr.REGION.amazonaws.com```
- Keep in mind that AWS charges $0.40/month for every secret stored.

## S3 Bucket
- Create an S3 Bucket to host Cloud Formation templates.
    - The bucket restrict public access
- Upload the ```microservice.yaml``` file into the bucket.
- Copy the Bucket URL for this file it will be used later when creating the stacks.
    - After uploading click the file and the Object URL should be visible in the **Object overview** section.

## Cloud Formation
Navigate to Cloud Formation section and click create stack. Click ```Template is Ready``` and ```Upload a template file```. The first template that should be created is ```vpc.yaml```.

### vpc.yaml
- Input any stack name and choose a key-value pair to use for connection to the Bastion host.
- Skip all other options and click Create Stack.
### database.yaml
- Input any stack name and enter a username and password for the database.
- Skip all other options and click Create Stack.
### cluster.yaml
- Input any stack name and paste the Object URL you copied earlier in the S3 section.
- Skip all other options, select the necessary checkboxes on the last page, and click Create Stack.

## Connecting To Database
- After successfully launching all resources, navigate to the database stack and click the outputs tab. Look for ```Database Endpoint```. This will be your MySql Hostname.
- Navigate to the vpc stack and select the outputs tab. Look for ```BastionHostIP```. This will be your SSH Hostname.
- Inside of Workbench select to setup a new connection. 
- For connection method select ```Standard TCP/IP over SSH```
- For SSH Hostname paste the ```BastionHostIP```.
- For SSH Username input ```ec2-user```.
- For SSH Key File select your stored private key file.
- For MySql Hostname input the ```Database Endpoint```.
- For Username and Password input the Username and Password you inputed during the creation of the database stack.
- Click Test Connection. 

After click Test Connection you may get a window that says Workbench was unable validate the ssh host. If there's an option for continue or connect just select that option and the connection should still go through successfully.

## Delete Stacks

Since the Database and Cluster stacks both rely on the VPC stack you'll need to get rid of both of those stacks first before you can delete the VPC stack.
