pipeline {
    environment {
        REGISTRY = 'salamislicing'
        REGISTRY_CREDENTIAL = 'salamislicing-docker'
        SERVICE = readMavenPom().getArtifact()
        VERSION = readMavenPom().getVersion()
    }
    agent none  
    stages {
        stage('Build') {
            agent {
                docker { image 'maven:3.8.1-adoptopenjdk-11' }
            }
            steps {
                    sh 'mvn clean package'
            }
        }
        stage('Docker Build') {
            steps {
                    sh "docker build -t ${REGISTRY}:${SERVICE}-${VERSION} ."
            }
        }
        stage('Docker Push') {
            steps {
                    withDockerRegistry([credentialsId: "${REGISTRY_CREDENTIAL}",url: ""]) {
                    sh "docker push ${REGISTRY}:${SERVICE}-${VERSION}"
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
