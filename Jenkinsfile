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
        stage('Check Dependencies') {
            steps {
                script {
                    echo "Checking Java version..."
                    def javaVersion = sh(script: "java -version 2>&1 | grep 'version' || true", returnStdout: true).trim()
                    if (!javaVersion.contains('21')) {
                        echo "Java 21 not found. Installing..."
                        sh '''
                            sudo apt update
                            sudo apt install -y wget gnupg
                            wget -O- https://apt.corretto.aws/corretto.key | sudo apt-key add -
                            echo 'deb https://apt.corretto.aws stable main' | sudo tee /etc/apt/sources.list.d/corretto.list
                            sudo apt update
                            sudo apt install -y java-21-amazon-corretto-jdk
                        '''
                    } else {
                        echo "Java 21 is already installed."
                    }

                    echo "Checking Maven..."
                    def mvnVersion = sh(script: "mvn -v || true", returnStdout: true).trim()
                    if (!mvnVersion.contains('Apache Maven')) {
                        echo "Maven not found. Installing..."
                        sh '''
                            sudo apt update
                            sudo apt install -y maven
                        '''
                    } else {
                        echo "Maven is already installed."
                    }

                    echo "Checking Chrome Headless..."
                    def chromeCheck = sh(script: "which google-chrome || true", returnStdout: true).trim()
                    if (chromeCheck == '') {
                        echo "Chrome not found. Installing..."
                        sh '''
                            sudo apt update
                            sudo apt install -y wget gnupg2
                            wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
                            echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
                            sudo apt update
                            sudo apt install -y google-chrome-stable
                        '''
                    } else {
                        echo "Chrome is already installed."
                    }
                }
            }
        }

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
