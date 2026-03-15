pipeline {
    agent any

    // Build parameters
    parameters {
        string(
            name: 'BRANCH_NAME',
            defaultValue: 'master',       // default branch if user does not provide
            description: 'Enter the Git branch to build (default is master)'
        )
        choice(
            name: 'ENV',
            choices: ['QA', 'UAT', 'staging', 'prod'],
            description: 'Select the Postman environment'
        )
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Sanikumar123/api_test.git',
                    branch: "${params.BRANCH_NAME}"
            }
        }

        stage('Run API Tests') {
            steps {
                script {
                    // Map ENV choice to actual JSON file
                    def envFile = "environments/${params.ENV}.postman_environment.json"

                    // Run Newman via Windows batch script
                    bat "scripts\\run_all.bat ${envFile}"
                }
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
            // Archive reports for download
            archiveArtifacts artifacts: 'reports/*', fingerprint: true
        }
    }
}