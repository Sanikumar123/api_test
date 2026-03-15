pipeline {
    agent any

    // Add build parameter for Git branch selection
    parameters {
        string(
            name: 'BRANCH_NAME',
            defaultValue: 'master',
            description: 'Enter the Git branch to build'
        )
    }

    stages {
        stage('Checkout') {
            steps {
                // Use the parameter value for Git checkout
                git url: 'https://github.com/Sanikumar123/api_test.git', branch: "${params.BRANCH_NAME}"
            }
        }

        stage('Run API Tests') {
            steps {
                sh 'chmod +x scripts/run_all.sh'
                sh './scripts/run_all.sh'
            }
        }

        stage('Publish HTML Reports') {
            steps {
                publishHTML(target: [
                    allowMissing: false,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'reports',
                    reportFiles: '*.html',
                    reportName: 'API Test Report'
                ])
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'reports/*', fingerprint: true
        }
        failure {
            mail to: 'team@example.com',
                 subject: "API Tests Failed: ${env.JOB_NAME} [${env.BUILD_NUMBER}]",
                 body: "Please check Jenkins build ${env.BUILD_URL}"
        }
    }
}