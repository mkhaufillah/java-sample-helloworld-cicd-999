pipeline {
    agent any

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['production', 'staging'], description: 'Select environment')
    }

    environment {
        PROJECT_REPO = 'https://github.com/mkhaufillah/java-sample-helloworld-cicd-999'
        TEST_REPO = 'https://github.com/mkhaufillah/automation-cicd-999'
    }

    stages {
        stage('Compile') {
            steps {
                script {
                    def branchName = params.ENVIRONMENT == 'production' ? 'main' : 'staging'
                    sh """
                        rm -rf java-sample-helloworld-cicd-999
                        git clone ${env.PROJECT_REPO}
                        cd java-sample-helloworld-cicd-999
                        git checkout ${branchName}
                        javac Sample.java
                    """
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    sh """
                        rm -rf automation-cicd-999
                        git clone ${env.TEST_REPO}
                        cd automation-cicd-999
                        git checkout main
                        mvn install -DskipTests
                        mvn test -DsuiteXml=src/test/resources/selenium_page_factory/runner_regresion_cucumber.xml -Denv=${params.ENVIRONMENT}
                    """
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh """
                        cd java-sample-helloworld-cicd-999
                        java Sample
                    """
                }
            }
        }
    }
}
