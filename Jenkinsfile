pipeline {

    agent {
        label "Roboshop"
    }

    options {
        timestamps()
        disableConcurrentBuilds()
        timeout(time: 15, unit: "MINUTES")

    }

    parameters {

        choice(
            name: "ACTION",
            choices: ["PLAN", "APPLY", "DESTROY"],
            description: "Terraform action to perform"
        )

        choice(
            name: "ENVIRONMENT",
            choices: ["dev", "prod"],
            description: "Environment to deploy"
        )
    }

    environment {

        AWS_REGION = "us-east-1"

        TF_IN_AUTOMATION = "true"

        TF_INPUT = "false"
    }

    stages {

        stage("Checkout") {

            steps {

                checkout scm
            }
        }

        stage("Terraform Format Check") {

            steps {

                sh """
                    terraform fmt -recursive
                """
            }
        }

        stage("Terraform Init & Workspace") {

            steps {

                script {

                    def layers = [
                        "00-vpc",
                        "10-sg",
                        "20-sg_rules",
                        "30-Jenkins",
                        "40-eks",
                        "50-acm",
                        "60-alb"
                    ]

                    for (layer in layers) {

                        dir(layer) {

                            echo "=========================================="
                            echo "Layer       : ${layer}"
                            echo "Environment : ${params.ENVIRONMENT}"
                            echo "=========================================="
                        withAWS(credentials: 'aws-creds', region: "${AWS_REGION}") {

                            sh """
                                terraform init -reconfigure -input=false
                        

                                terraform workspace select -or-create ${params.ENVIRONMENT}

                                echo "Current Terraform workspace:"
                                terraform workspace show
                            """
                        }

                            
                        }
                    }
                }
            }
        }

        stage("Terraform Validation") {

            steps {

                script {

                    def layers = [
                        "00-vpc",
                        "10-sg",
                        "20-sg_rules",
                        "30-Jenkins",
                        "40-eks",
                        "50-acm",
                        "60-alb"
                    ]

                    for (layer in layers) {

                        dir(layer) {

                            sh """
                                terraform validate
                            """
                        }
                    }
                }
            }
        }


        /*
         * -------------------------------------------------------
         * PLAN
         * -------------------------------------------------------
         */

        stage("Terraform Plan") {

            when {

                expression {
                    params.ACTION == "PLAN" ||
                    params.ACTION == "APPLY"
                }
            }

            steps {

                script {

                    def layers = [
                        "00-vpc",
                        "10-sg",
                        "20-sg_rules",
                        "30-Jenkins",
                        "40-eks",
                        "50-acm",
                        "60-alb"
                    ]

                    for (layer in layers) {

                        dir(layer) {

                            echo "Planning ${layer} for ${params.ENVIRONMENT}"

                            if (fileExists("${params.ENVIRONMENT}.tfvars")) {
                                
                                withAWS(credentials: 'aws-creds', region: "${AWS_REGION}") {
                                sh """
                                    terraform plan \
                                    -input=false \
                                    -var-file=${params.ENVIRONMENT}.tfvars \
                                    -out=tfplan

                                    terraform show \
                                    -no-color tfplan \
                                    > tfplan.txt
                                """
                                }

                            } else {

                                sh """
                                    terraform plan \
                                    -input=false \
                                    -out=tfplan

                                    terraform show \
                                    -no-color tfplan \
                                    > tfplan.txt
                                """
                            }
                        }
                    }
                }
            }
        }

        stage("Production Approval") {

            when {

                allOf {

                    expression {
                        params.ACTION == "APPLY"
                    }

                    expression {
                        params.ENVIRONMENT == "prod"
                    }
                }
            }

            steps {

                input(
                    message: "Approve Terraform deployment to PRODUCTION?",
                    ok: "Deploy to Production"
                )
            }
        }

        stage("Terraform Apply") {

            when {

                expression {
                    params.ACTION == "APPLY"
                }
            }

            steps {

                script {

                    def layers = [
                        "00-vpc",
                        "10-sg",
                        "20-sg_rules",
                        "30-Jenkins",
                        "40-eks",
                        "50-acm",
                        "60-alb"
                    ]

                    for (layer in layers) {

                        dir(layer) {

                            echo "=========================================="
                            echo "Applying layer       : ${layer}"
                            echo "Environment          : ${params.ENVIRONMENT}"
                            echo "Terraform workspace  : ${params.ENVIRONMENT}"
                            echo "=========================================="

                            sh """
                                terraform workspace show

                                terraform apply \
                                -input=false \
                                -auto-approve \
                                tfplan
                            """
                        }
                    }
                }
            }
        }

        stage("Destroy Approval") {

            when {

                expression {
                    params.ACTION == "DESTROY"
                }
            }

            steps {

                script {

                    if (params.ENVIRONMENT == "prod") {

                        input(
                            message: "WARNING: You are about to DESTROY PRODUCTION infrastructure. Continue?",
                            ok: "Destroy Production"
                        )

                    } else {

                        input(
                            message: "WARNING: Destroy DEV infrastructure?",
                            ok: "Destroy DEV"
                        )
                    }
                }
            }
        }


        /*
         * -------------------------------------------------------
         * DESTROY
         * -------------------------------------------------------
         */

        stage("Terraform Destroy") {

            when {

                expression {
                    params.ACTION == "DESTROY"
                }
            }

            steps {

                script {

                    def layers = [
                        "60-alb",
                        "50-acm",
                        "40-eks",
                        "30-Jenkins",
                        "20-sg_rules",
                        "10-sg",
                        "00-vpc"
                    ]

                    for (layer in layers) {

                        dir(layer) {

                            echo "=========================================="
                            echo "Destroying layer     : ${layer}"
                            echo "Environment          : ${params.ENVIRONMENT}"
                            echo "Terraform workspace  : ${params.ENVIRONMENT}"
                            echo "=========================================="


                            if (fileExists("${params.ENVIRONMENT}.tfvars")) {

                                sh """
                                    terraform destroy \
                                    -input=false \
                                    -auto-approve \
                                    -var-file=${params.ENVIRONMENT}.tfvars 
                            
                                """

                            } else {

                                sh """
                                    terraform destroy \
                                    -input=false \
                                    -auto-approve
                                """
                            }
                        }
                    }
                }
            }
        }
    }


    /*
     * -----------------------------------------------------------
     * POST ACTIONS
     * -----------------------------------------------------------
     */

    post {

        always {

            archiveArtifacts(
                artifacts: "**/tfplan.txt",
                allowEmptyArchive: true
            )
        }

        success {

            echo "=========================================="
            echo "Terraform pipeline completed successfully"
            echo "Environment : ${params.ENVIRONMENT}"
            echo "Action      : ${params.ACTION}"
            echo "=========================================="
        }

        failure {

            echo "=========================================="
            echo "Terraform pipeline FAILED"
            echo "Environment : ${params.ENVIRONMENT}"
            echo "Action      : ${params.ACTION}"
            echo "=========================================="
        }
    }
}