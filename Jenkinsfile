pipeline {
    environment {
        REGISTRY = 'salamislicing'
        REGISTRY_CREDENTIAL = 'salamislicing-docker'
        SERVICE = 'demo'
        VERSION = '0.0.1-SNAPSHOT'
    }
    agent { node { label 'master' } }
    stages {
        stage('Build') {
            steps {
                    sh 'export M2_HOME=/usr/local/apache-maven'
                    sh 'export M2=$M2_HOME/bin'
                    sh 'export PATH=$M2:$PATH'
                    sh '/usr/local/apache-maven/bin/mvn clean package'
            }
        }
        stage('Docker Build') {
            steps {
                    sh "docker build -t ${REGISTRY}:${SERVICE}-${VERSION} ."
                    sh "export IMAGE_ID=`docker image ls --filter reference=*${SERVICE}* -q`"
                    sh "docker tag $IMAGE_ID ${REGISTRY}/${SERVICE}:${VERSION}"
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
