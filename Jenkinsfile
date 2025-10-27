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

    stage('Build and Package') {
        steps {
            echo 'Building application package...'
            // FIX: Replacing the invalid 'zip' step with a reliable shell command
            // This zips the 'webapp' directory into 'webapp.zip'
            sh 'zip -r webapp.zip webapp'
        }
    }

    stage('Deploy to Azure VM') {
        steps {
            echo "Deploying to ${VM_USERNAME}@${VM_PUBLIC_IP}..."
            
            // Ensure we are using the 'sh' step for Linux commands, not 'bat' (Windows)
            // Assuming Jenkins is running on a Linux agent (default for most setups)
            sshagent(credentials: [SSH_CREDENTIAL_ID]) {
                // 1. Copy the built archive to the VM
                sh """
                    # Copy the built archive to the VM
                    scp -o StrictHostKeyChecking=no webapp.zip ${VM_USERNAME}@${VM_PUBLIC_IP}:/home/${VM_USERNAME}/

                    # 2. Connect to the VM and run deployment commands
                    ssh -o StrictHostKeyChecking=no ${VM_USERNAME}@${VM_PUBLIC_IP} "
                        
                        # Install unzip and pip3 if not present (added pip3 install)
                        sudo apt-get update
                        sudo apt-get install -y unzip python3-pip

                        # Create a directory for the new deployment
                        mkdir -p ~/app_deploy/
                        
                        # Unzip the new code, overwriting existing files (-o)
                        unzip -o ~/webapp.zip -d ~/app_deploy/
                        
                        # Remove the zip file to clean up
                        rm ~/webapp.zip

                        # Install/update dependencies
                        pip3 install -r ~/app_deploy/webapp/requirements.txt

                        # Stop any old running version of the app
                        pkill -f 'python3 app.py' || true

                        # Start the new app in the background
                        cd ~/app_deploy/webapp/
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
