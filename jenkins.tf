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

  template = "file://job_config.xml"
}
