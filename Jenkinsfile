pipeline {
    agent any
    stages {
        stage('SCM Checkout'){
            steps {
            git branch: 'main', credentialsId: 'jen-cred', url: 'https://github.com/st-naresh/sub-micro.git'
            sh 'ls'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                parallel (
                    'node application': {
                        script {
                            dir('cart-microservice-nodejs') {
                                def scannerHome = tool 'sonarscanner4'
                                 withSonarQubeEnv('sonar-pro') {
                                     sh "${scannerHome}/bin/sonar-scanner"
                                 }
                            }
                            dir('ui-web-app-reactjs') {
                                def scannerHome = tool 'sonarscanner4';
                                withSonarQubeEnv('sonar-pro') {
                                    sh "${scannerHome}/bin/sonar-scanner"
                                }
                            }

                        }
                    },
                    'spring boot application': {
                        script {
                            dir('offers-microservice-spring-boot') {
                                def mvn = tool 'maven3';
                                withSonarQubeEnv('sonar-pro') {
                                    sh "${mvn}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=offers-spring-boot -Dsonar.projectName=offers-spring-boot"
                                }
                            }
                            dir('shoes-microservice-spring-boot') {
                                def mvn = tool 'maven3';
                                withSonarQubeEnv('sonar-pro') {
                                    sh "${mvn}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=shoe-spring-boot -Dsonar.projectName=shoes-spring-boot"
                                }
                            }
                            dir('zuul-api-gateway') {
                                def mvn = tool 'maven3';
                                withSonarQubeEnv('sonar-pro') {
                                    sh "${mvn}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=zuul-api -Dsonar.projectName=zuul-api"
                                }
                            }
                        }
                    },
                    'python app': {
                        script{
                            dir('wishlist-microservice-python') {
                                def scannerHome = tool 'sonarscanner4';
                                withSonarQubeEnv('sonar-pro') {
                                    sh """/var/lib/jenkins/tools/hudson.plugins.sonar.SonarRunnerInstallation/sonarscanner4/bin/sonar-scanner \
                                    -D sonar.projectVersion=1.0-SNAPSHOT \
                                    -D sonar.sources=. \
                                    -D sonar.login=admin \
                                    -D sonar.password=admin \
                                    -D sonar.projectKey=project \
                                    -D sonar.projectName=wishlist-py \
                                    -D sonar.inclusions=index.py \
                                    -D sonar.sourceEncoding=UTF-8 \
                                    -D sonar.language=python \
                                    -D sonar.host.url=http://180.151.249.202:9000/"""
                                }
                            }
                        }
                    }
                )
            }
        }
        stage ('Build Docker Image and push'){
            steps {
                parallel (
                    'docker login': {
                        withCredentials([string(credentialsId: 'dockerPass', variable: 'dockerPassword')]) {
                            sh "docker login -u comdevops -p ${dockerPassword}"
                        }
                    },
                    'ui-web-app-reactjs': {
                        dir('ui-web-app-reactjs'){
                            sh """
                            docker images
                            docker build -t comdevops/ui:v10 .
                            docker push comdevops/ui:v10
                            docker rmi comdevops/ui:v10
                            """
                        }
                    },
                    'zuul-api-gateway' : {
                        dir('zuul-api-gateway'){
                            sh """
                            docker build -t comdevops/api:v3 .
                            docker push comdevops/api:v3
                            docker rmi comdevops/api:v3"""
                        }
                    },
                    'offers-microservice-spring-boot': {
                        dir('offers-microservice-spring-boot'){
                            sh """
                            docker build -t comdevops/spring:v2 .
                            docker push comdevops/spring:v2
                            docker rmi comdevops/spring:v2
                            """
                        }
                    },
                    'shoes-microservice-spring-boot': {
                        dir('shoes-microservice-spring-boot'){
                            sh """
                            docker build -t comdevops/spring:v4 .
                            docker push comdevops/spring:v4
                            docker rmi comdevops/spring:v4
                            """
                        }
                    },
                    'cart-microservice-nodejs': {
                        dir('cart-microservice-nodejs'){
                            sh """
                            docker build -t comdevops/ui:v3 .
                            docker push comdevops/ui:v3
                            docker rmi comdevops/ui:v3
                            """
                        }
                    },
                    'wishlist-microservice-python': {
                        dir('wishlist-microservice-python'){
                            sh """
                            docker build -t comdevops/python:v2 .
                            docker push comdevops/python:v2
                            docker rmi comdevops/python:v2
                            """
                        }
                    }
                )
            }
        }
        stage ('Deploy on k8s'){
            steps {
                parallel (
                    'deploy on k8s': {
                        script {
                            //sh 'minikube stop'
                            //sh 'minikube delete'
                            //sh 'minikube start'
                            sh 'minikube status'
                            //sh 'kubectl create ns ms'
                            //sh 'kubectl config set-context --current --namespace=ms'
                           // sh 'kubectl create secret docker-registry javapipe --docker-username comdevops --docker-password Dev-ops@123'
                           // sh 'kubectl get secret -n ms javapipe -oyaml> secret.yaml'
                            //sh 'kubectl apply -f secret.yaml'
                            //sh 'kubectl create secret generic javapipe --from-file=.dockerconfigjson=/opt/docker/config.json -n ms --type kubernetes.io/dockerconfigjson --dry-run=client -oyaml > secret.yaml'
                            //sh 'kubectl apply -f secret.yaml'
                        }
                    },
                    'ui-web-app-reactjs': {
                        dir('ui-web-app-reactjs'){
                            sh 'kubectl apply -f kube.yaml'
                            //sh 'kubectl get secrets'
                            sh 'kubectl get pods -o wide'
                            sh 'kubectl get svc'
                            sh 'kubectl get node -o wide'
                            sh 'kubectl get deployment'
                            //sh 'kubectl describe pod react-ui'
                        }
                    },
                    'zuul-api-gateway': {
                        dir('zuul-api-gateway'){
                            sh 'kubectl apply -f kube.yaml'
                            sh 'kubectl get pods -o wide'
                            sh 'kubectl get svc'
                            sh 'kubectl get node -o wide'
                            sh 'kubectl get deployment'
                        }
                    },
                    'shoes-microservice-spring-boot': {
                        dir('shoes-microservice-spring-boot'){
                            sh 'kubectl apply -f kube.yaml'
                            sh 'kubectl get pods -o wide'
                            sh 'kubectl get svc'
                            sh 'kubectl get node -o wide'
                            sh 'kubectl get deployment'
                        }
                    },
                    'offers-microservice-spring-boot': {
                        dir('offers-microservice-spring-boot'){
                            sh 'kubectl apply -f kube.yaml'
                            sh 'kubectl get pods -o wide'
                            sh 'kubectl get svc'
                            sh 'kubectl get node -o wide'
                            sh 'kubectl get deployment'
                        }
                    },
                    'cart-microservice-nodejs':{
                        dir('cart-microservice-nodejs'){
                            sh 'kubectl apply -f kube.yaml'
                            sh 'kubectl get pods -o wide'
                            sh 'kubectl get svc'
                            sh 'kubectl get node -o wide'
                            sh 'kubectl get deployment'
                            
                        }
                    },
                    'wishlist-microservice-python':{
                        dir('wishlist-microservice-python'){
                            sh 'kubectl apply -f kube.yaml'
                            sh 'kubectl get pods -o wide'
                            sh 'kubectl get svc'
                            sh 'kubectl get node -o wide'
                            sh 'kubectl get deployment'
                        }
                    }

                )
            }
        }
    }
} 
