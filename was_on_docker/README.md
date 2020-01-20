# How to build this image


### STEP 1: update env variable
Update IBMid, IBMid_password, IBM_Installation_Manager_download_url variables with email, password and IBM download URL

NOTE: Verify that password should not have any special characters

### STEP 2: Get IBM WAS Download URL 
Use the following instructions
 https://github.com/WASdev/ci.docker.websphere-traditional/blob/master/docker-build/download-iim.md

### STEP 3: Invoke script to Build Docker Image and deploy it
Run createwasdocker.sh script

## STEP 4: IBM web console login
Navigate to 
https://localhost:9043/ibm/console/login.do?action=secure

user: wsadmin
pwd: get from cat /tmp/PASSWORD

sudo docker exec -t {cont-id} cat /tmp/PASSWORD
