#!/usr/bin/groovy

@Library(['github.com/indigo-dc/jenkins-pipeline-library@1.2.2']) _

pipeline {
    agent {
        label 'docker-build'
    }

    environment {
        dockerhub_repo = "deephdc/deep-oc-mods"
    }

    stages {
        stage('DockerHub delivery') {
            when {
                anyOf {
                    branch 'master'
                    buildingTag()
                }
            }
            steps{
                checkout scm
                script {
                    image_id = DockerBuild(
                                    dockerhub_repo,
                                    tag: env.BRANCH_NAME)
                }
            }
            post {
                success {
                    DockerPush(image_id)
                }
                failure {
                    DockerClean()
                }
                always {
                    cleanWs()
                }
            }
        }
    }
}
