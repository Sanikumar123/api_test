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

        stage('Install Node Dependencies') {
            steps {
                script {
                    // Ensure Node dependencies are installed (newman + html reporter)
                    bat 'npm install'
                }
            }
        }

        stage('Run API Tests') {
            steps {
                script {
                    def envFile = "environments/${params.ENV}.postman_environment.json"

                    // Run Newman via batch file, continue even if tests fail
                    bat(script: "scripts\\run_all.bat ${envFile}", returnStatus: true)
                }
            }
        }

        stage('Publish HTML Reports') {
            steps {
                // Publish the Newman HTML report correctly
                publishHTML(target: [
                    reportDir: 'reports',        // folder containing report.html
                    reportFiles: 'report.html',  // actual report file
                    reportName: 'API Test Report',
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    allowMissing: false
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