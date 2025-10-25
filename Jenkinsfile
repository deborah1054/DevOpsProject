pipeline {
    agent any

    environment {
        // *** This section is now updated ***
        
        // 1. This is your new VM's Public IP
        VM_PUBLIC_IP = '4.213.57.24' 
        
        // 2. This is the admin username from your variables.tf
        VM_USERNAME = 'azureuser' 
        
        // 3. This is the ID we will create in Jenkins
        SSH_CREDENTIAL_ID = 'azure-vm-ssh-key' 
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code...'
                // This will be automatically set by the Jenkins job
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Building application package...'
                // This zips the webapp folder into webapp.zip
                zip zipFile: 'webapp.zip', dir: 'webapp'
            }
        }

        stage('Deploy to Azure VM') {
            steps {
                echo "Deploying to ${VM_USERNAME}@${VM_PUBLIC_IP}..."
                
                // Use the sshagent wrapper to securely handle SSH credentials
                sshagent(credentials: [SSH_CREDENTIAL_ID]) {
                    // 'bat' means this runs in a Windows command prompt
                    bat """
                        :: 1. Copy the built archive to the VM
                        :: We need to install ssh/scp on Windows first.
                        :: For now, let's assume it's installed.
                        scp -o StrictHostKeyChecking=no webapp.zip ${VM_USERNAME}@${VM_PUBLIC_IP}:/home/${VM_USERNAME}/

                        :: 2. Connect to the VM and run deployment commands
                        ssh -o StrictHostKeyChecking=no ${VM_USERNAME}@${VM_PUBLIC_IP} "
                            
                            # Install unzip if not present
                            sudo apt-get update
                            sudo apt-get install -y unzip
                            
                            # Create a directory for the new deployment
                            mkdir -p ~/app_deploy/
                            
                            # Unzip the new code
                            unzip -o ~/webapp.zip -d ~/app_deploy/
                            
                            # Remove the old archive
                            rm ~/webapp.zip

                            # Install/update dependencies
                            pip3 install -r ~/app_deploy/requirements.txt

                            # Stop any old running version of the app
                            pkill -f 'python3 app.py' || true

                            # Start the new app in the background
                            cd ~/app_deploy/
                            export GREETING='CI/CD Success'
                            nohup python3 app.py > app.log 2>&1 &
                            
                            echo 'Deployment complete!'
                        "
                    """
                }
            }
        }
    }
}
