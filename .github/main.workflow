workflow "GitHub Page" {
  on = "push"
  resolves = ["Deploy to GitHub Pages"]
}

action "Dev Master Only" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Install" {
  uses = "nuxt/actions-yarn@master"
  args = "install"
  needs = ["Dev Master Only"]
}

action "Build" {
  uses = "nuxt/actions-yarn@master"
  args = "build"
  needs = ["Install"]
}

action "Deploy to GitHub Pages" {
  uses = "maxheld83/ghpages@v0.2.1"
  env = {
    BUILD_DIR = "build/"
  }
  needs = ["Build"]
  secrets = ["GH_PAT"]
}
