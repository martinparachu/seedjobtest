pipelineJob("stg_update") {
  parameters {
    stringParam('s3BucketName',"mhplat-nonprod-devops", 'S3 Credentials Bucket')
    choiceParam('source', ["val"], 'Source Database' )
    choiceParam('target', ["stg", "dev"], 'Target Database' )
  }

  definition {
    cps {
      sandbox()
      script( readFileFromWorkspace('stg_update.jenkinsfile') )
    }
  }

}
