pipeline {
    environment {
        REGISTRY = 'salamislicing'
        REGISTRY_CREDENTIAL = 'salamislicing-docker'
        SERVICE = 'demo'
        VERSION = '0.1.2'
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
                    sh '''
                    export IMAGE_ID=`docker image ls --filter reference=*${SERVICE}* -q`
                    docker image rm -f $IMAGE_ID
                    docker build -t ${REGISTRY}:${SERVICE}-${VERSION} .
                    export IMAGE_ID=`docker image ls --filter reference=*${SERVICE}* -q`
                    docker tag $IMAGE_ID ${REGISTRY}/${SERVICE}:${VERSION}
                    '''
            }
        }
        stage('Docker Push') {
            steps {
                    withDockerRegistry([credentialsId: "${REGISTRY_CREDENTIAL}",url: ""]) {
                    sh "docker push ${REGISTRY}/${SERVICE}:${VERSION}"
            }

        }
    }
        stage('K3S Deploy') {
            steps {
                    sh '''
                    export KUBECONFIG=/var/lib/jenkins/k3s.yaml
                    /usr/local/bin/helm package ${SERVICE} --version ${VERSION}
                    /usr/local/bin/helm upgrade --history-max=5 --install --namespace=demo --timeout=10m0s --version=${VERSION} --wait=true ${SERVICE} ${SERVICE}-${VERSION}.tgz
                    '''
            }
        }
    }
}
