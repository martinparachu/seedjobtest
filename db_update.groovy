pipelineJob("db_update") {
  parameters {
    choiceParam('target', ["stg"], 'Target Database' )
    booleanParam('run_update', false, 'Check if you really want to proceed')
  }

  definition {
    cps {
      sandbox()
      script( readFileFromWorkspace('db_update.jenkinsfile') )
    }
  }

}
