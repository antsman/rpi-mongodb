#!/groovy

pipeline {
    agent any
    environment {
        DOCKER_CREDS = credentials('DOCKER_HUB_CREDS')
        IMAGE_NAME = 'antsman/rpi-mosquitto'
        IMAGE_TAG = "ci-jenkins-$BRANCH_NAME"
        CONTAINER_NAME = "$BUILD_TAG"
    }
     stages {
        stage('BUILD') {
            steps {
                sh "docker build -t $IMAGE_NAME:$IMAGE_TAG ."
            }
        }
        stage('TEST') {
            steps {
                sh "docker run -d --rm --name $CONTAINER_NAME $IMAGE_NAME:$IMAGE_TAG"
                sh "docker exec -t $CONTAINER_NAME mosquitto -h | grep version"
                sh "./get-versions.sh $CONTAINER_NAME"   // Get mosquitto and alpine version in started container, store in env.properties
                load './env.properties'
                echo "$MOSQUITTO_VERSION"
                echo "$ALPINE_VERSION"
                sh "time docker stop $CONTAINER_NAME"
            }
        }
        stage('DEPLOY') {
            when {
                branch 'master'
            }
            steps {
                echo 'Build succeeded, push image ..'
                sh "docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:latest"
                sh "docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:$MOSQUITTO_VERSION"
                sh "docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:$MOSQUITTO_VERSION-$ALPINE_VERSION"
                sh "docker login -u $DOCKER_CREDS_USR -p $DOCKER_CREDS_PSW"
                sh "docker push $IMAGE_NAME:latest"
                sh "docker push $IMAGE_NAME:$MOSQUITTO_VERSION"
                sh "docker push $IMAGE_NAME:$MOSQUITTO_VERSION-$ALPINE_VERSION"
            }
        }
    }
    post {
        failure {
            sh "docker rm -f $CONTAINER_NAME"
        }
    }
}

