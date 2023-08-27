pipeline 
{
    agent any
    environment {
        DOCKER_HUB_CREDENTIAL = credentials('DOCKER_HUB_CREDENTIAL')
        KUBECONFIG = credentials('KUBECONFIG')
    }


     stages {
        stage('Clone Repository') {
            steps {
                // Clone your repository
                git 'https://github.com/YeswanthKondri/Databricks.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build the Docker image
                
                    sh "docker build -t yeswanthkondri/databricks-frontend:'${env.BUILD_ID}' -f Dockerfile  ."
            }
        } 
        
        stage('Push Docker Image') 
        {
            steps {
                

                script {
                    // Retrieve Docker Hub credentials
                      def dockerHubUsername = DOCKER_HUB_CREDENTIAL_USR
                      def dockerHubPassword = DOCKER_HUB_CREDENTIAL_PSW

                    // Docker login using the retrieved credentials
                    sh "docker login -u ${dockerHubUsername} -p ${dockerHubPassword}"

                    // Push Docker image
                    
                    sh "docker push yeswanthkondri/databricks-frontend:'${env.BUILD_ID}'"
                }
            
            }
        } 
        
         stage('Deploying Image to K8s CLuster')
        {
            steps {

                script {
                     def kubeconfigContent = KUBECONFIG

                    // Store the Kubeconfig content in a temporary file
                    def kubeconfigPath = "${env.WORKSPACE}/kubeconfig.yaml"
                    writeFile file: kubeconfigPath, text: kubeconfigContent

                    // Set KUBECONFIG environment variable
                    env.KUBECONFIG = kubeconfigPath
              
                    // Use kubectl or other k8s CLI commands
                    //sh "sed -i 's/image: yeswanthkondri/databricks-frontend/image: yeswanthkondri/databricks-frontend:'$BUILD_ID'/g' deployment.yaml"
                    sh "sed -i 's#image: yeswanthkondri/databricks-frontend#image: yeswanthkondri/databricks-frontend:'$BUILD_ID'#g' deployment.yaml"
                    sh 'kubectl apply -f pvc.yaml -n databricks '
                    sh 'kubectl apply -f deployment.yaml -n databricks'
                    
                }
            }


        }
            

    }
}
    
