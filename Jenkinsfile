
pipeline {
    agent any

    parameters {
        booleanParam(name: 'CLEAN_WORKSPACE', defaultValue: false, description: 'Delete Jenkins map')
        booleanParam(name: 'TESTING_FRONTEND', defaultValue: false, description: 'FRONTEND TEST')
    }

    environment {
        ON_SUCCESS_SEND_EMAIL = true
        ON_FAILURE_SEND_EMAIL = true
    }

    stages {

        stage("Fetch repository") {
            steps {
                git 'https://github.com/Valeriy099/clone-js-app-1527.git'
            }
        }

        stage("Building") {
            steps {
                echo "Build number ${BUILD_NUMBER} and ${BUILD_TAG}"
                bat 'npm install'
                bat 'npm install is-ci --save'
                bat 'npm i jest-cli -g'
                bat 'npm i @jest/core'
                bat 'npm install jest-junit'
                bat 'npm install chai'
                bat 'npm install junit-xml'
            }
        }

        stage("Backend test") {
            steps {
                echo "TESTING_BACKEND"
                script{
                    TESTING_FRONTEND = true
                } 
                bat 'npm test'
                
            }
        }

        stage("Frontend test") {
            steps {
                script{
                    if(TESTING_FRONTEND == true){
                        echo "TESTING_FRONTEND"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Job ran successfully"
            script {
                ON_SUCCESS_SEND_EMAIL = true
            }
        }

        unstable {
            echo "The build is unstable"
        }

        failure {
            echo "Something wrong happened"
            script {
                ON_SUCCESS_SEND_EMAIL = false
            }
        }

        always {
            echo "Build Tag: ${BUILD_TAG}"
            script{
                if (params.CLEAN_WORKSPACE == false){
                    echo 'Deleting current map'
                    cleanWs()
                    CLEAN_WORKSPACE = true
                }
            }

            script {
                if (CLEAN_WORKSPACE == true) {
                    echo 'Deleting BUILD_TAG folder'
                    bat 'rm -rf ${BUILD_TAG}'
                    ON_SUCCES_SEND_EMAIL = true
                } else {
                    echo 'BUILD_TAG folder has not been deleted'
                }

                if(ON_SUCCESS_SEND_EMAIL == true){
                    emailext body: "Pipeline SUCCESS!\nJOB_NAME: ${JOB_NAME}\nBUILD_NUMBER: ${BUILD_NUMBER}\nBUILD_URL: ${BUILD_URL}",
                    subject: 'All is ok!', to: 'popa.valeriu@isa.utm.md'
                }
                else{
                    emailext body: "Pipeline ERROR!\nJOB_NAME: ${JOB_NAME}\nBUILD_NUMBER: ${BUILD_NUMBER}\nBUILD_URL: ${BUILD_URL}",
                    subject: 'Some errors!', to: 'popa.valeriu@isa.utm.md'
                }
            }

            junit '*/junit.xml'

        }

    }
}
