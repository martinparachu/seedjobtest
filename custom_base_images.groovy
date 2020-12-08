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
			'dotnet-3.1-runtime_node'
			],
			'Choose the docker image to generate.'
		)
	}

    scm {
        git {
            remote {
		    
	      url('https://github.com/martinparachu/seedjobtest.git')			    
              //url('https://ps-devops@bitbucket.org/primerosystems/ps-devops.git')
              //credentials('bitbucket-credential')
            }
            branch('master')
        }
    }

	steps {
		shell(
'''
set -x

case ${DOCKER_IMAGE} in

"dotnet-3.1-runtime_node")
  ECR_REPO=dotnet-runtime
  IMAGE_NAME=dotnet-runtime-node-3.1
  ;;

esac

ECR_URL=mwlrancher01t.midwestlabs.com:5000
IMAGE_TAG=${ECR_URL}/${ECR_REPO}:${IMAGE_NAME}
# DOCKERFILE=${WORKSPACE}/jobs/devops/custom-base-images/${IMAGE_NAME}.dockerfile
DOCKERFILE=${WORKSPACE}/${IMAGE_NAME}.dockerfile

echo "Build ${DOCKER_IMAGE} docker image..."

# Build the docker image
docker build -f ${DOCKERFILE} -t ${IMAGE_NAME} .

# Login, tag and push to ECR
docker tag ${IMAGE_NAME}:latest ${IMAGE_TAG}
# docker push ${IMAGE_TAG}
docker rmi ${IMAGE_TAG}
''')
	}
}
