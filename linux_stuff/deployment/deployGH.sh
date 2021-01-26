# ------------------------------------------------------------------------
#
# TheEye.io - Bash Boilerplate for writing script tasks
#
# ------------------------------------------------------------------------

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
export HOME=/root/
export LANG=en_US.UTF-8  
export LANGUAGE=en_US:en  
export LC_ALL=en_US.UTF-8 

github_token="--- TOKEN HERE ---"
if echo $github_token | grep TOKEN;then  
  echo "Please set the \$github_token
        In order to accomplish this task you should create a personal token for a specific user (https://docs.github.com/es/github/authenticating-to-github/creating-a-personal-access-token) 
        1- Create a new github user, if it doesn't exists and invite him to this repository
        2- Login with that user you already created on the last step and then go to https://github.com/settings/tokens and create a new token
        3- you are a brave man"
exit 1
fi

#alias echo="printf"

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
  #output=$(tr -d '\r|\n' < output.json)
  # jq alternative (recommended)
  output=$(cat output.json | jq -c '.')
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
  source /etc/theeye/theeye.conf
  cd $APP_PATH

  systemDependenciesCheck
  
  githubSourcesDeploy "${REPO_NAME}" "${APP_PATH}" "${BRANCH}"

  # build the JSON output if needed
  cat << EOF > ./output.json
[]
EOF
  
  # output.json will be handled for you
  return 0 # success exit code
}

function systemDependenciesCheck {

  echo "checking system dependencies"

  if ! hash node &> /dev/null
  then
    echo "nodejs not be found"
    exit 1
    #curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
    #sudo apt-get install -y nodejs
    #sudo apt-get install -y gcc g++ make
  fi

  echo "checking node"
  which node && node --version || echo 'node not found'
  which nodejs && nodejs --version || echo 'nodejs not found'
  which npm && npm --version || echo 'npm not found'
  
  echo "scripts-prepend-node-path=true" > .npmrc
  
  if ! which jq > /dev/null;then 
     apt-get update -y
     apt-get install -y git jq ssh gitsome
  fi
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
  
  if [[ ! -d "${path}/${name}" ]]
  then
    echo "creating repo"
    gh repo clone ${repo} 
  fi
  
  cd "${path}/${name}"
  echo "now on ${PWD}"

  echo "pulling sources"
  git fetch
  git reset --hard origin/master	
  echo "ready to install dependencies"
  npm install
}

main
success_output
