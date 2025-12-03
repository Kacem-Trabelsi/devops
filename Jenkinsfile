pipeline {
    agent any
    
    tools {
        maven 'M2_HOME'
    }
    
    stages {
        stage('GIT') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Kacem-Trabelsi/devops.git',
                    credentialsId: 'jenkins-github-credentials'
            }
        }
}

