def call(){
    node {
        stage('Checkout') {
            checkout scm
        }

        // Execute different stages depending on the job
        if(env.JOB_NAME.contains("api")){
            
            if(env.BRANCH_NAME.contains("master")){
                buildAPIprod()
            } else if(env.BRANCH_NAME.contains("dev")) {
                buildAPIdev()
            }
            
        } else if(env.JOB_NAME.contains("web")) {

            if(env.BRANCH_NAME.contains("master")){
                buildWEBprod()
            } else if(env.BRANCH_NAME.contains("dev")) {
                buildWEBdev()
            }

        }
    }
}


def buildAPIdev(){
    stage("Build API"){
        echo "BUILD API APPLICATION FOR DEV"
    }
}

def buildAPIprod(){
    stage("Build API"){
        echo "BUILD API APPLICATION FOR PROD"
    }
}

def buildWEBdev(){
    stage("Build WEB"){
        echo "BUILD WEB APPLICATION FOR DEV"
    }
}

def buildWEBprod(){
    stage("Build WEB"){
        echo "BUILD API APPLICATION FOR PROD"
    }
}

