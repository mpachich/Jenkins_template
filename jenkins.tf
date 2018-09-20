provider "jenkins" {
  server_url = "${var.jenkins_url}"
  username   = "${var.jenkins_username}"
  password   = "${var.jenkins_password}"
}

resource "jenkins_job" "first" {
  name         = "${var.job_name}"
  display_name = "${var.display_name}"
  description  = "This makes a project using terraform"
  disabled     = false

  parameters = {
    ProjectURL = "${var.github_project_url}"
  }

  template = <<EOF
  <flow-definition plugin="workflow-job@2.24">
  <actions/>
  <description></description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <com.coravy.hudson.plugins.github.GithubProjectProperty plugin="github@1.29.2">
      <projectUrl>${var.github_project_url}</projectUrl>
      <displayName></displayName>
    </com.coravy.hudson.plugins.github.GithubProjectProperty>
    <org.jenkinsci.plugins.workflow.job.properties.PipelineTriggersJobProperty>
      <triggers>
        <hudson.triggers.SCMTrigger>
          <spec>* * * * *</spec>
          <ignorePostCommitHooks>false</ignorePostCommitHooks>
        </hudson.triggers.SCMTrigger>
      </triggers>
    </org.jenkinsci.plugins.workflow.job.properties.PipelineTriggersJobProperty>
  </properties>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition" plugin="workflow-cps@2.54">
    <script>node{
      stage ('Code Fetch'){
    checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'http://github.com/mpachich/helloWorld.git']]])

sh '''if [ -d "helloWorld" ];
  then
    cd helloWorld
    git pull origin master
  else
    git clone http://github.com/mpachich/helloWorld.git
      cd helloWorld
  fi'''
  }
  stage ('Build'){
  sh '''
    javac helloWorld.java
    java helloWorld'''
    }
}
</script>
    <sandbox>true</sandbox>
  </definition>
  <triggers/>
  <disabled>false</disabled>
</flow-definition>
EOF
}
