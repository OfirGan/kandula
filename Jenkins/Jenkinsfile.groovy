properties([parameters([choice(choices: ['disabled','enabled'], name: 'deploy', description: 'Should Deploy the Knadula 🐘 app?')])])

docker_registry = "https://registry.hub.docker.com/"
docker_repo = "ofirgan/kandula-app"
docker_ver = "v1.0"
dockerhub_creds_id = "dockerhub.ofirgan"

github_repo_ssh_Path = "git@github.com:OfirGan/kandula-project-app.git"
github_branch = 'mid-project'
github_creds_id = "github.ofirgan"

echo "Deploy is: ${params.deploy}"

node(label: "docker"){
    stage('Clone Kandula App Repo to Worker Node') {
        script {
            git branch: "${github_branch}", credentialsId: "${github_creds_id}", url: "${github_repo_ssh_Path}"
        }
    }
    stage("Build Dockerfile") {
        dockerImage = docker.build("${docker_repo}:${docker_ver}")
    }
    stage("Docker Push") {
        docker.withRegistry("${docker_registry}", "${dockerhub_creds_id}") {
            dockerImage.push()
        }
    }

    if (deploy.equals('enabled')) {
        stage('Create K8s Deployment file') {
            withCredentials([string(credentialsId: 'aws.access_key', variable: 'AWS_ACCESS_KEY_ID'), string(credentialsId: 'aws.secret_key', variable: 'AWS_SECRET_ACCESS_KEY'), string(credentialsId: 'aws.region', variable: 'AWS_DEFAULT_REGION')]) {
                dep = sh """
                        tee kanduka-app-deployment.yaml <<-'EOF'
                        apiVersion: apps/v1
                        kind: Deployment
                        metadata:
                          name: kanduka-app-deployment
                          annotations:
                            kubernetes.io/change-cause: "First deploy of Kandula app"
                        spec:
                          replicas: 1
                          selector:
                            matchLabels:
                              app: kandula-app
                          template:
                            metadata:
                              labels:
                                app: kandula-app
                            spec:
                              containers:
                                - name: kandula
                                  image: benbense/kandula-app:v1.0
                                  env:
                                    - name: FLASK_ENV
                                      value: "development"
                                    - name: AWS_ACCESS_KEY_ID
                                      value: "${AWS_ACCESS_KEY_ID}"
                                    - name: AWS_SECRET_ACCESS_KEY
                                      value: "${AWS_SECRET_ACCESS_KEY}"
                                    - name: AWS_DEFAULT_REGION
                                      value: "${AWS_DEFAULT_REGION}"
                                  ports:
                                    - containerPort: 5000
                                      name: http
                                      protocol: TCP
                    """
            }
        }

        stage('Create K8s Service file') {
            svc = sh """
                    tee kandula-app-service.yaml <<-'EOF'
                    apiVersion: v1
                    kind: Service
                    metadata:
                      name: kandula-app-service
                    spec:
                      selector:
                        app: kandula-app
                      type: LoadBalancer
                      ports:
                        - name: http
                          port: 80
                          targetPort: 5000
                          protocol: TCP
                    """
        }

        stage ('K8S Deploy Application') {
          sh 'kubectl apply -f kandula-app-deployment.yaml'
        }

        stage ('K8S Deploy Service') {
          sh 'kubectl apply -f kandula-app-service.yaml'
        }
    }
}