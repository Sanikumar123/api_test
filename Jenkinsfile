pipeline {
    agent any

    parameters {
        choice(
            name: 'RUN_MODE',
            choices: ['Specific Collection', 'All Collections'],
            description: 'Choose whether to run a specific collection or all collections'
        )
        string(
            name: 'COLLECTION',
            defaultValue: '',
            description: 'Enter collection file name (without .postman_collection.json) if RUN_MODE is "Specific Collection"'
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

                    if (params.RUN_MODE == 'Specific Collection') {
                        if (!params.COLLECTION) {
                            error "Collection name is required for RUN_MODE = Specific Collection"
                        }
                        def collFile = "collections/${params.COLLECTION}.postman_collection.json"
                        bat "newman run ${collFile} -e ${envFile} -r cli,html --reporter-html-export reports/${params.COLLECTION}_report.html"
                    } else {
                        // Dynamically list all collection files in the collections folder
                        def collFiles = bat(script: 'dir /b collections\\*.postman_collection.json', returnStdout: true).trim().split('\r\n')
                        for (collFile in collFiles) {
                            def collName = collFile.replace('.postman_collection.json','')
                            bat "newman run collections\\${collFile} -e ${envFile} -r cli,html --reporter-html-export reports\\${collName}_report.html"
                        }
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