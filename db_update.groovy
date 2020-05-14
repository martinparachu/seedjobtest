pipelineJob("db_update") {
  parameters {
    stringParam('s3BucketName',"mhplat-nonprod-devops", 'S3 Credentials Bucket')
    choiceParam('source', ["val"], 'Source Database' )
    choiceParam('target', ["stg", "dev"], 'Target Database' )
    booleanParam('run_update', false, 'Check if you really want to proceed')
  }

  definition {
    cps {
      sandbox()
      script( readFileFromWorkspace('db_update.jenkinsfile') )
    }
  }

}
