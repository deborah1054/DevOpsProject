pipeline {
    agent any

    environment {
        // *** This section defines your target VM details ***
        
        // 1. This is your Azure VM's Public IP
        VM_PUBLIC_IP = '4.213.57.24' 
        
        // 2. This is the admin username for your Azure VM
        VM_USERNAME = 'azureuser' 
        
        // 3. This is the ID of the SSH credential you created in Jenkins
        SSH_CREDENTIAL_ID = 'azure-vm-ssh-key' 
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code...'
                // Fetches the code from your GitHub repository
                checkout scm
            }
        }

        stage('Build and Package') {
            steps {
                echo 'Building application package...'
                // FIX: Using a standard shell command to create the zip file
                // This zips the 'webapp' directory into 'webapp.zip'
                sh 'zip -r webapp.zip webapp'
            }
        }

        stage('Deploy to Azure VM') {
            steps {
                // This echo MUST show "Deploying to azureuser@4.213.57.24..."
                echo "Deploying to ${VM_USERNAME}@${VM_PUBLIC_IP}..." 
                
                // Uses the SSH key credential to securely connect
                sshagent(credentials: [SSH_CREDENTIAL_ID]) {
                    // Uses standard Linux shell commands for deployment
                    sh """
                        # Copy the built archive to the VM
                        # Uses the correct environment variables for username and IP
                        scp -o StrictHostKeyChecking=no webapp.zip ${VM_USERNAME}@${VM_PUBLIC_IP}:/home/${VM_USERNAME}/

                        # Connect to the VM and run deployment commands
                        # Uses the correct environment variables for username and IP
                        ssh -o StrictHostKeyChecking=no ${VM_USERNAME}@${VM_PUBLIC_IP} "
                            
                            # Ensure necessary packages are installed on the VM
                            sudo apt-get update
                            sudo apt-get install -y unzip python3-pip

                            # Create the deployment directory if it doesn't exist
                            mkdir -p ~/app_deploy/
                            
                            # Unzip the new code, overwriting existing files
                            unzip -o ~/webapp.zip -d ~/app_deploy/
                            
                            # Remove the uploaded zip file
                            rm ~/webapp.zip

                            # Install Python dependencies from requirements.txt
                            # NOTE: Assumes requirements.txt is inside the webapp folder within the zip
                            pip3 install -r ~/app_deploy/webapp/requirements.txt

                            # Stop any previously running instance of the app
                            pkill -f 'python3 app.py' || true

                            # Change directory and start the new app in the background
                            # NOTE: Assumes app.py is inside the webapp folder within the zip
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
