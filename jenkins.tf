provider "jenkins" {
  server_url = "http://localhost:8080/"
  username   = "user1"
  password   = "user1"
}

resource "jenkins_job" "first" {
  name         = "TerrTest"
  display_name = "First terraform test"
  description  = "This makes a project using terraform"
  disabled     = false

  parameters = {}
  template   = "file://./job_config.xml"
}
