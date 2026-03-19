pipeline {
    agent any

    parameters {
        choice(
            name: 'RUN_OPTION',
            choices: ['All', 'Specific'],
            description: 'Run all collections or a specific one'
        )
        string(
            name: 'SPECIFIC_COLLECTION',
            defaultValue: '',
            description: 'Collection name WITHOUT .json (e.g., E2EECom)'
        )
        choice(
            name: 'ENV',
            choices: ['QA', 'UAT', 'staging', 'prod'],
            description: 'Select environment'
        )
        string(
            name: 'TEST_DATA_FILE',
            defaultValue: '',
            description: 'Optional CSV file from test_data folder'
        )
        string(
            name: 'BRANCH_NAME',
            defaultValue: 'master',
            description: 'Git branch'
        )
    }

    stages {

        stage('Checkout') {
            steps {
                git url: 'https://github.com/Sanikumar123/api_test.git',
                    branch: "${params.BRANCH_NAME}"
            }
        }

        stage('Install Newman') {
            steps {
                bat '''
                echo Installing Newman...
                npm install -g newman

                echo Installing HTML Reporter...
                npm install -g newman-reporter-htmlextra

                newman -v
                '''
            }
        }

        stage('Validate Inputs') {
            steps {
                script {
                    if (params.RUN_OPTION == 'Specific' && !params.SPECIFIC_COLLECTION) {
                        error "SPECIFIC_COLLECTION is required"
                    }
                }
            }
        }

        stage('Run API Tests') {
            steps {
                script {
                    def envFile = "environments/${params.ENV}.postman_environment.json"
                    def testDataArg = params.TEST_DATA_FILE ? params.TEST_DATA_FILE : ""

                    echo "ENV: ${params.ENV}"
                    echo "RUN_OPTION: ${params.RUN_OPTION}"

                    if (params.RUN_OPTION == 'All') {
                        bat "scripts\\run_all.bat ${envFile} All \"\" ${testDataArg}"
                    } else {
                        bat "scripts\\run_all.bat ${envFile} Specific ${params.SPECIFIC_COLLECTION} ${testDataArg}"
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
        success {
            echo '✅ API Tests Passed'
        }
        failure {
            echo '❌ API Tests Failed'
        }
    }
}