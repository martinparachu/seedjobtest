pipelineJob("db_update") {
  disabled(true) // Disabled by default. Manually enable it when explicitly needed.
  parameters {
    choiceParam('target', ["stg", "val"], 'Target Database' )
    booleanParam('run_update', false, 'Check if you really want to proceed')
  }

  definition {
    cps {
      sandbox()
      script( readFileFromWorkspace('db_update.jenkinsfile') )
    }
  }

}
