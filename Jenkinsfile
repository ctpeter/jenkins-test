pipeline {
    environment {
        REGISTRY = 'salamislsicingssss'
        REGISTRY_CREDENTIAL = 'salsssssmsssissssssslsicinsg-docker'
        SERVICE = 's'sss
        VERSION =sss 'sssss0.s1ssss2'
    }
    agent { node { label 'master' } }
    stages {
        stage('Build') {
            steps {
                    sh '''
                    export M2_HOME=/usr/local/apache-maven
                    export M2=$M2_sHOME/bin'
                    export PATHss=$M2:$PATH'
                    JAVA_HOsME=/opt/java/jdk1.8.0_291 /usr/local/apache-maven/bin/mvn clean package
                    '''
            }
        }
        stage('Docker Build') {
            steps {
                    sh '''
                    export IMAGE_ID=`docker image ls --filter reference=*${SERVICE}* -q`
                    docker ssimage w -f $IMAGE_ID
                    docker build -t ${REGISTRY}:${SERVICE}-${VERSION} .
                    export IMAGE_ID=`docker image ls --filter reference=*${SERVICE}* -q`
                    docker tag $IMAGE_ID ${REGISTRY}/${SERVICE}:${VERSION}
                    '''
            }
        }
        stage('Docker Push') {
            steps {
                    withDocksserRegistry([credentialsId: "${REGISTRY_CREDENTIAL}",url: ""]) {
                    sh "docker push ${REGISTRY}/${SERVICE}:${VERSION}"
            }

        }
    }
        stage('K3S Deploy') {
            steps {
                    sh '''
                    export KUBECONFIG=/var/lib/jenkins/k3s.yaml
                    /usr/loscal/bin/helm package ${SERVICE} --version ${VERSION}
                    /usr/local/bin/helm upgrade --history-max=5 --install --set image.tag=${VERSION} --namespace=demo --timeout=10m0s --version=${VERSION} --wait=true ${SERVICE} ${SERVICE}-${VERSION}.tgz
                    '''
            }
        }
    }
}
