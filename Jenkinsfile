
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
                git 'https://github.com/APG17/tidpp4.git/'
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
        
        stage("Continuous Delivery") {
            steps {
                echo "Push all to DockerHub"
                bat 'docker push valeriy099/tidpp-4'
            }
        }
        
        stage("Continuous Deployment") {
            steps {
                echo "Docker Build & docker-compose"
                bat 'docker build . -t valeriy099/tidpp-4 && docker-compose up'
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
                ON_FAILURE_SEND_EMAIL = false
            }
        }

        always {
            echo "Build Tag: ${BUILD_TAG}"
            script{
                cleanWs()
                CLEAN_WORKSPACE = true
            }

            script {
                if (CLEAN_WORKSPACE == true) {
                    echo 'Deleting BUILD_TAG folder'
                    deleteDir()
                    dir("${workspace}@tmp") {
                        deleteDir()}
                } else {
                    echo 'BUILD_TAG folder has not been deleted'
                }

                if(ON_SUCCESS_SEND_EMAIL == true){
                    emailext body: "Pipeline SUCCESS!\nJOB_NAME: ${JOB_NAME}\nBUILD_NUMBER: ${BUILD_NUMBER}\nBUILD_URL: ${BUILD_URL}",
                    subject: 'All is ok!', to: 'valeriy13099@gmail.com'
                }
                else{
                    emailext body: "Pipeline ERROR!\nJOB_NAME: ${JOB_NAME}\nBUILD_NUMBER: ${BUILD_NUMBER}\nBUILD_URL: ${BUILD_URL}",
                    subject: 'Some errors!', to: 'valeriy13099@gmail.com'
                }
            }

           // junit '*/JUnit_Report.xml'

        }

    }
}
