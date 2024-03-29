#!/bin/bash
# ------------------------------------------------------------------------
#
# TheEye.io - Bash Boilerplate for writing script tasks
#
# ------------------------------------------------------------------------

export LANG=en_US.UTF-8  
export LANGUAGE=en_US:en  
export LC_ALL=en_US.UTF-8 

github_token=""
if echo $github_token | grep TOKEN;then  
  echo "Please set the \$github_token
        In order to accomplish this task you should create a personal token for a specific user (https://docs.github.com/es/github/authenticating-to-github/creating-a-personal-access-token) 
        1- Create a new github user, if it doesn't exists and invite him to this repository
        2- Login with that user you already created on the last step and then go to https://github.com/settings/tokens and create a new token
        3- you are a brave man"
exit 1
fi

function catch_output
{
  if [ "$1" != "0" ];
  then
	  echo "Error $1 occurred on $2" && failure_output
  fi
}

function failure_output
{
  echo "{\"state\":\"failure\",\"data\":[\"error\"]}"
  exit 1
}

function success_output
{
  # remove end of line characters
  output=$(tr -d '\r|\n' < output.json)
  printf '{"state":"success","data":%b}' "${output}"
  exit 0
}

# ------------------------------------------------------------------------
#
# write your code into main function
#
# ------------------------------------------------------------------------
function main 
{
  cd $APP_PATH
  
  githubSourcesDeploy "${REPO_NAME}" "${APP_PATH}" "${BRANCH}"

  # build the JSON output if needed
  cat << EOF > ./output.json
[]
EOF
  
  # output.json will be handled for you
  return 0 # success exit code
}

function githubSourcesDeploy {
  echo "app sources deploy"
  
  name="${1}"
  repo="https://github.com/theeye-io/${name}.git"
  path="${2}"
  branch="${3:-master}"

  mkdir -p ~/.config/gh/

  echo "github.com:
    oauth_token: $github_token
    git_protocol: https
    user: comafi-bots" > ~/.config/gh/hosts.yml
  
  echo "[credential \"https://github.com\"]
        helper = !gh auth git-credential" > ~/.gitconfig

  echo "checking repo ${name} in ${path}"
  
  cd ${path}
  
  echo "now on ${PWD}"

  echo "pulling sources"
  git fetch
  git reset --hard https/master	
  echo "ready to install dependencies"
  npm install
}

main
success_output