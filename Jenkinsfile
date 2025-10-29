// Define environment variables - Jenkins will replace these with secrets later
environment {
    // IDs must match the credentials created in Jenkins
    FIREBASE_CONFIG_JSON = credentials('firebase-config-json')
    GEMINI_API_KEY = credentials('gemini-api-key')
}

pipeline {
    agent any 

    stages {
        stage('Checkout') { // 1. Get the code from GitHub
            steps {
                // Replace 'main' with 'master' if your branch name is different
                git url: 'https://github.com/AayushKumar1144/ai-companion.git', branch: 'main' 
            }
        }

        stage('Inject Secrets') { // 2. Replace placeholders with real secrets
            steps {
                script {
                    echo 'Injecting Firebase and Gemini API Keys...'
                    // Read the template index.html
                    def htmlContent = readFile 'index.html'

                    // Replace placeholders with the actual values from Jenkins credentials
                    htmlContent = htmlContent.replace('__FIREBASE_CONFIG_PLACEHOLDER__', env.FIREBASE_CONFIG_JSON)
                    htmlContent = htmlContent.replace('__GEMINI_KEY_PLACEHOLDER__', env.GEMINI_API_KEY)

                    // Write the modified content back to index.html (this is the file Docker will use)
                    writeFile file: 'index.html', text: htmlContent
                    echo 'Secrets injected successfully.'
                }
            }
        }

        stage('Build Docker Image') { // 3. Build the Nginx container image
            steps {
                script {
                    def imageName = "ai-companion:latest"
                    // Build the Docker image using the Dockerfile in the current directory
                    sh "docker build -t ${imageName} ."
                    echo "Docker image built: ${imageName}"
                }
            }
        }

        stage('Deploy Container') { // 4. Stop any old container and run the new one
            steps {
                script {
                    def imageName = "ai-companion:latest"
                    def containerName = "ai-companion-app"

                    // Stop and remove any previous running container
                    echo "Stopping and removing old container if exists..."
                    sh "docker stop ${containerName} || true" // || true prevents pipeline failure if container doesn't exist
                    sh "docker rm ${containerName} || true"

                    // Run the new container
                    // Map port 80 inside the container to port 80 on the EC2 host
                    sh "docker run -d --name ${containerName} -p 80:80 ${imageName}"
                    echo "Deployment complete. App available on EC2 Public IP:80"
                }
            }
        }
    } 

    post {
        always {
            // Clean up the Jenkins workspace to save space
            cleanWs()
        }
    }
}