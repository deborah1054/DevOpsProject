pipeline {
agent any

environment {
// Keep the localhost IP (127.0.0.1) for deployment since Jenkins is running on the same VM as the target
REMOTE_HOST = "127.0.0.1"
// UPDATED: Use your new VM username
REMOTE_USER = "Deborahm1054"
// UPDATED: Use the new username in the remote path
REMOTE_PATH = "/home/${REMOTE_USER}/DevOpsProject"
}

stages {
stage('Declarative: Checkout SCM') {
steps {
checkout scm
}
}

stage('Checkout') {
    steps {
        echo "Checking out code..."
        checkout scm
    }
}

stage('Build and Package') {
    steps {
        echo "Building application package..."
        // Zip the 'webapp' folder (containing app.py, requirements.txt, and templates)
        sh 'zip -r webapp.zip webapp'
    }
}

stage('Deploy to Azure VM') {
    steps {
        echo "Deploying to ${REMOTE_USER}@${REMOTE_HOST}..."
        
        // Note: You must ensure the SSH key credential 'azure-vm-ssh-key' in Jenkins 
        // is configured with the key pair corresponding to the new VM's user.
        sshagent(credentials: ['azure-vm-ssh-key']) {
            // 1. Copy the zip file to the remote host using scp
            sh "scp -o StrictHostKeyChecking=no webapp.zip ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PATH}/"
            
            // 2. SSH into the remote host and run deployment script
            sh """
            ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} 'bash -s' < ./deploy.sh
            """
        }
    }
}


}

}
