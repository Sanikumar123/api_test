pipeline {
    agent any

    parameters {
        string(name: 'BRANCH_NAME', defaultValue: 'master', description: 'Git branch to build')
        choice(name: 'ENV', choices: ['QA', 'UAT', 'staging', 'prod'], description: 'Select Postman environment')
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/Sanikumar123/api_test.git', branch: "${params.BRANCH_NAME}"
            }
        }

        stage('Install Node Dependencies') {
            steps {
                script {
                    // Install dependencies from package.json
                    bat 'npm install'
                }
            }
        }

        stage('Run API Tests') {
            steps {
                script {
                    def envFile = "environments/${params.ENV}.postman_environment.json"
                    def exitCode = bat(script: "scripts\\run_all.bat ${envFile}", returnStatus: true)
                    if (exitCode != 0) {
                        echo "Some tests failed! See HTML report."
                        currentBuild.result = 'UNSTABLE'
                    }
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