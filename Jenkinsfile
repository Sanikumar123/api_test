pipeline {
    agent any

    parameters {
        string(
            name: 'BRANCH_NAME',
            defaultValue: 'master',
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
                    // Continue even if tests fail to ensure HTML report is generated
                    bat(script: "scripts\\run_all.bat ${envFile}", returnStatus: true)
                }
            }
        }

        stage('Publish HTML Reports') {
            steps {
                // Publish the Newman HTML report
                publishHTML(target: [
                    allowMissing: false,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'reports',
                    reportFiles: 'report.html',
                    reportName: 'API Test Report'
                ])
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'reports/*', fingerprint: true
        }
    }
}