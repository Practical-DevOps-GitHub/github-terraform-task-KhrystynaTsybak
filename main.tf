provider "github" {
  token = var.github_token
}

resource "github_repository" "example_repo" {
  name        = "github-terraform-task-KhrystynaTsybak"
  description = "description"
  private     = true

  default_branch = "develop"
}

resource "github_repository_collaborator" "example_collaborator" {
  repository = github_repository.example_repo.name
  username   = "softservedata"
  permission = "push"
}

resource "github_branch_protection" "main_protection" {
  repository = github_repository.example_repo.name
  branch     = "main"

  required_pull_request_reviews {
    dismiss_stale_reviews          = true
    require_code_owner_reviews     = true
    required_approving_review_count = 1
  }

  enforce_admins = true
}

resource "github_branch_protection" "develop_protection" {
  repository = github_repository.example_repo.name
  branch     = "develop"

  required_pull_request_reviews {
    dismiss_stale_reviews          = true
    required_approving_review_count = 2
  }
}

resource "github_file" "pull_request_template" {
  repository = github_repository.example_repo.name
  branch     = "main"
  file_path  = ".github/pull_request_template.md"
  content    = file("${path.module}/pull_request_template.md")
}
