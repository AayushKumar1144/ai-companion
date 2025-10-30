pipeline {
    agent any 

    // Define environment variables - Jenkins will replace these with secrets later
    // This block is now INSIDE the 'pipeline' block, which is correct.
    environment {
        // IDs must match the credentials created in Jenkins
        FIREBASE_CONFIG_JSON = credentials('firebase-config-json')
        GEMINI_API_KEY = credentials('gemini-api-key')
    }

    stages {
        stage('Checkout') { // 1. Get the code from GitHub
            steps {
                git url: 'https://github.com/AayushKumar1144/ai-companion.git', branch: 'main'
            }
        }

        stage('Inject Secrets') { // 2. Replace placeholders with real secrets
            steps {
                script {
                    echo 'Injecting Firebase and Gemini API Keys...'
                    def htmlContent = readFile 'index.html'

                    // These env variables will now work
                    htmlContent = htmlContent.replace('__FIREBASE_CONFIG_PLACEHOLDER__', env.FIREBASE_CONFIG_JSON)
                    htmlContent = htmlContent.replace('__GEMINI_KEY_PLACEHOLDER__', env.GEMINI_API_KEY)

                    writeFile file: 'index.html', text: htmlContent
                    echo 'Secrets injected successfully.'
                }
            }
        }

        stage('Build Docker Image') { // 3. Build the Nginx container image
            steps {
                script {
                    def imageName = "ai-companion:latest"
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

                    echo "Stopping and removing old container if exists..."
                    sh "docker stop ${containerName} || true"
                    sh "docker rm ${containerName} || true"

                    sh "docker run -d --name ${containerName} -p 80:80 ${imageName}"
                    echo "Deployment complete. App available on EC2 Public IP:80"
                }
            }
        }
    } 

    post {
        always {
            cleanWs()
        }
    }
} 