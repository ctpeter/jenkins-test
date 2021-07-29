pipeline {
    environment {
        REGISTRY = salamislicing
        REGISTRY_CREDENTIAL = 'salamislicing-docker'
    }
    agent {
        kubernetes {
            defaultContainer 'salamiscling'
            yamlFile 'build.yaml'
        }
    }
    stages {
        stage('Build') {
            steps {
                container('maven') {
                    sh 'mvn clean package'
                }
            }
        }
        stage('Docker Build') {
            steps {
                container('docker') {
                    sh "docker build -t ${REGISTRY}:${SERVICE-NAME}-${VERSION} ."
                }
            }
        }
        stage('Docker Push') {
            steps {
                container('docker'){
                    withDockerRegistry([credentialsId: "${REGISTRY_CREDENTIAL}",url: "")
                        sh "docker push ${REGISTRY}:${SERVICE-NAME}-${VERSION}"
                }
            }

        }
    }
        stage('K3S Deploy') {
            steps {
                container('helm') {
                    sh "helm package charts/${SERVICE} --app-version ${VERSION}"
                    sh "helm upgrade --history-max=5 --install=true --namespace=salami --timeout=10m0s --version=${VERSION} --wait=true ${SERVICE} ${SERVICE}-${VERSION}.tgz ./helm"
                }
            }
        }
    }
}
