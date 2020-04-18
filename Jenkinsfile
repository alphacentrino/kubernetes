pipeline {
    agent any
    environment {
        PROJECT_ID = 'pure-vehicle-272119'
        CLUSTER_NAME = 'k8s'
        LOCATION = 'us-central1-a'
        CREDENTIALS_ID = 'pure-vehicle-272119'
    }
    stages {
        stage("Checkout code") {
            steps {
                checkout scm
            }
        }
        stage('Build') { 
            steps {
                sh './mvnw clean install package' 
            }
        }
        stage("Build image") {
            steps {
                script {
                    myapp = docker.build("rdocker11/simple-devops-image:${env.BUILD_ID}")
                }
            }
        }
        stage("Push image") {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
                            myapp.push("latest")
                            myapp.push("${env.BUILD_ID}")
                    }
                }
            }
        }        
        stage('Deploy to GKE') {
            steps{
                sh "sed -i 's/simple-devops-image:latest/simple-devops-image:${env.BUILD_ID}/g' deployment.yaml"
                step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'deployment.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
            }
        }
    }    
}
