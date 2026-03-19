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
            description: 'Enter collection file name if RUN_OPTION is Specific'
        )
        choice(
            name: 'ENV',
            choices: ['QA', 'UAT', 'staging', 'prod'],
            description: 'Select Postman environment'
        )
        string(
            name: 'TEST_DATA_FILE',
            defaultValue: '',
            description: 'Optional: provide CSV file name from test_data folder'
        )
        string(
            name: 'BRANCH_NAME',
            defaultValue: 'master',
            description: 'Git branch to build'
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
                        error "SPECIFIC_COLLECTION is required when RUN_OPTION=Specific"
                    }
                }
            }
        }

        stage('Run API Tests') {
            steps {
                script {
                    def envFile = "environments/${params.ENV}.postman_environment.json"
                    def testDataArg = params.TEST_DATA_FILE ? params.TEST_DATA_FILE : ""

                    echo "Running tests with ENV: ${params.ENV}"
                    echo "Using env file: ${envFile}"

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
                    reportName: 'API Test Reports (HTMLExtra)'
                ])
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'reports/*', fingerprint: true
        }
        success {
            echo 'API Tests Passed ✅'
        }
        failure {
            echo 'API Tests Failed ❌'
        }
    }
}