pipeline {
    agent any

    // Parameter to select Git branch at build time
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
                // Pull the selected branch from Git
                git url: 'https://github.com/Sanikumar123/api_test.git',
                    branch: "${params.BRANCH_NAME}"
            }
        }

        stage('Run API Tests') {
            steps {
                // Run the Windows batch script
                bat 'scripts\\run_all.bat'
            }
        }

        stage('Publish HTML Reports') {
            steps {
                // Publish all Newman HTML reports in Jenkins
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
            // Archive reports for reference
            archiveArtifacts artifacts: 'reports/*', fingerprint: true
        }
    }
}