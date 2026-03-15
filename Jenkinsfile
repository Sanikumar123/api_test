pipeline {
    agent any

    parameters {
        choice(
            name: 'RUN_OPTION',
            choices: ['All', 'Specific'],
            description: 'Choose All to run all collections, or Specific to run a single collection'
        )
        string(
            name: 'SPECIFIC_COLLECTION',
            defaultValue: '',
            description: 'Enter the collection file name (only if RUN_OPTION is Specific)'
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
                    branch: "${params.BRANCH_NAME ?: 'master'}"
            }
        }

        stage('Install Node Dependencies') {
            steps {
                bat 'npm install'
            }
        }

        stage('Run API Tests') {
            steps {
                script {
                    def envFile = "environments/${params.ENV}.postman_environment.json"

                    if (params.RUN_OPTION == 'All') {
                        // Loop through all collections in the folder
                        bat """
                        for %%f in (collections\\*.postman_collection.json) do (
                            newman run %%f -e ${envFile} -r cli,html --reporter-html-export reports\\%%~nf_report.html
                        )
                        """
                    } else if (params.RUN_OPTION == 'Specific') {
                        if (!params.SPECIFIC_COLLECTION) {
                            error "SPECIFIC_COLLECTION parameter is empty. Please provide a collection name."
                        }
                        bat """
                        newman run collections\\${params.SPECIFIC_COLLECTION} -e ${envFile} -r cli,html --reporter-html-export reports\\${params.SPECIFIC_COLLECTION}_report.html
                        """
                    }
                }
            }
        }

        stage('Publish HTML Reports') {
            steps {
                publishHTML(target: [
                    allowMissing: true,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'reports',
                    reportFiles: '*.html',
                    reportName: 'API Test Reports'
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