pipelineJob("stg_update") {


  definition {
    cps {
      sandbox()
      script( readFileFromWorkspace('stg_update.jenkinsfile') )
    }
  }

}
