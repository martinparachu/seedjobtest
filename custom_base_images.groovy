job("custom-base-images") {
	logRotator {
		numToKeep 30
	}
	description()
	keepDependencies(false)
	disabled(false)
	concurrentBuild(false)

	parameters {
		choiceParam(
			"DOCKER_IMAGE",
			[
			'dotnet-2-runtime',
			'dotnet-3.1-runtime',
			'dotnet-5.0-aspnet',
			'dotnet-2-runtime-psx',
      'dotnet-2-sdk-sonarqube',
      'dotnet-3-sdk-sonarqube',
      'dotnet-5-sdk-sonarqube',
			'node-8.15-jessie',
			'node-12.16.2-buster'
			],
			'Choose the docker image to generate.'
		)
	}

    scm {
        git {
            remote {
              url('https://ps-devops@bitbucket.org/primerosystems/ps-devops.git')
              credentials('bitbucket-credential')
            }
            branch('master')
        }
    }

	steps {
		shell(
'''
set -x

case ${DOCKER_IMAGE} in
"dotnet-2-runtime")
  ECR_REPO=dotnet-runtime
  IMAGE_NAME=dotnet-runtime-2.1-pip-awscli
  ;;
 "dotnet-2-runtime-psx")
  ECR_REPO=dotnet-runtime
  IMAGE_NAME=dotnet-runtime-2.1-psx
  ;;
"dotnet-2-sdk-sonarqube")
  ECR_REPO=dotnet-sdk
  IMAGE_NAME=dotnet-sdk-2.1-sonarqube
  ;;
"dotnet-3-sdk-sonarqube")
  ECR_REPO=dotnet-sdk
  IMAGE_NAME=dotnet-sdk-3.1-sonarqube
  ;;
"dotnet-5-sdk-sonarqube")
  ECR_REPO=dotnet-sdk
  IMAGE_NAME=dotnet-sdk-5.0-sonarqube
  ;;
"node-8.15-jessie")
  ECR_REPO=node
  IMAGE_NAME=node-8.15-jessie-pip-awscli
  ;;
"node-12.16.2-buster")
  ECR_REPO=node
  IMAGE_NAME=node-12.16.2-buster-pip-awscli
  ;;
"dotnet-3.1-runtime")
  ECR_REPO=dotnet-runtime
  IMAGE_NAME=dotnet-runtime-3.1-pip-awscli
  ;;
"dotnet-5.0-aspnet")
  ECR_REPO=aspnet
  IMAGE_NAME=dotnet-aspnet-5.0-pip-awscli
  ;;
esac

ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
ECR_URL=${ACCOUNT_ID}.dkr.ecr.us-west-2.amazonaws.com
IMAGE_TAG=${ECR_URL}/${ECR_REPO}:${IMAGE_NAME}
DOCKERFILE=${WORKSPACE}/jobs/devops/custom-base-images/${IMAGE_NAME}.dockerfile

echo "Build ${DOCKER_IMAGE} docker image..."

# Build the docker image
docker build -f ${DOCKERFILE} -t ${IMAGE_NAME} .

# Login, tag and push to ECR
aws ecr get-login --no-include-email --region us-west-2 | sh
docker tag ${IMAGE_NAME}:latest ${IMAGE_TAG}
docker push ${IMAGE_TAG}
docker rmi ${IMAGE_TAG}
''')
	}
}
