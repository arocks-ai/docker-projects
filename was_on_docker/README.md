# How to build this image


### STEP 1: update env variable
Update IBMid, IBMid_password, IBM_Installation_Manager_download_url variables with email, password and IBM download URL

NOTE: Verify that password should not have any special characters

### STEP 2: Get IBM WAS Download URL 
Use the following instructions
 https://github.com/WASdev/ci.docker.websphere-traditional/blob/master/docker-build/download-iim.md

### STEP 3: Build Docker Image
Run createwasdocker.sh script

