terraform {
    extra_arguments "custom_vars" {
    commands = [
      "apply",
      "plan",
      "import",
      "push",
      "refresh"
    ]
    required_var_files = ["${get_parent_terragrunt_dir()}/variables.tfvars"]
  }
}

inputs = {}
