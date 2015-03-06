#!/bin/bash

# Wait for method
function ask
{
  style blue-bold
  read -e -p '>>> ' cmd
  style normal
  
  history -s $cmd
  cmd=(${cmd// / })
  execute cmd[@]
}

# Autocompletion support for methods
function autocomplete
{
  set -o emacs
  bind 'set show-all-if-ambiguous on'
  bind 'set completion-ignore-case on'

  COMP_WORDBREAKS=${COMP_WORDBREAKS//:}

  #bind TAB:menu-complete
  bind 'TAB:dynamic-complete-history'

  history -s "branch all go pull hardpull diff clean reset delete"
  history -s "tag get all go"
  history -s "project install update chown"
  history -s "composer install update list"
  history -s "ls clean script quit"
}

# Execute given method
function execute
{
  # split string into an array
  N=("${!1}")

  case ${N[0]} in
    
    branch)
      cmd_branch ${N[1]} ${N[2]}
      ;;

    tag)
      cmd_tag ${N[1]} ${N[2]}
      ;;

    go)
      cd
      bash update.sh $project ${N[1]}
      exit 0
      ;;

    ls)
      ls -la ${N[2]}
      ;;

    clean)
      git branch --merged | grep -v "\*" | xargs -n 1 git branch -d
      log "info" "Already-merged branches deleted!"
      ;;

    composer)
      cmd_composer ${N[1]}
      ;;

    project)
      cmd_project ${N[1]} ${N[2]}
      ;;

    sh)
      file=${N[1]}".sh"
      if [ -f $file ]; then
        log "info" "$(pwd)/$file"
        bash $file
      else
        log "error" "Script not found!"
      fi
      ;;

    quit)
      exit 0
      ;;

    *) help ;;

  esac

  ask
}

function cmd_branch
{

  case $1 in 
        
    all)
      git fetch -q
      git branch 
      ;;

    go)
      git fetch -q
      git checkout $2
      ;;

    pull)
      git fetch -q
      git pull -a
      random_phrase
      ;;

    hardpull)
      git fetch -q
      git reset --hard origin/$2
      ;;

    diff)
      git diff
      ;;

    clean)
      git checkout .
      log "info" "Branch cleaned!"
      ;;

    reset)
      git reset --hard HEAD
      ;;

    delete)
      git branch -D $2
      ;;

    *) help ;;

  esac
}

function cmd_tag
{
  case $1 in 
        
    get)
      git fetch --tags
      echo $(git describe --tags)
      ;;

    all)
      git fetch --tags
      echo $(git tag | xargs -I@ git log --format=format:"%ai @%n" -1 @ | sort | awk '{print $4}')
      ;;

    go)
      git fetch --tags
      git checkout $2
      ;;

    *) help ;;

  esac
}

function cmd_composer
{
  case $1 in 

    install)
      ~/composer.phar install --no-dev
      ;;

    update)
      ~/composer.phar update --no-dev
      ;;

    list)
      ~/composer.phar show -i
      ;;

    *) help ;;

  esac
}

function cmd_project
{
  case $1 in 

    install)
      if [ -f scripts/install.sh ]; then
        log "info" "$(pwd)/scripts/install.sh"
        bash scripts/install.sh
      else
        log "error" "Script not found!"
      fi
      ;;

    update)
      if [ -f scripts/update.sh ]; then
        log "info" "$(pwd)/scripts/install.sh"
        bash scripts/update.sh
      else
        log "error" "Script not found!"
      fi
      ;;

    chown)
      chown -R $2:$2 *
      log "info" "Permissions changed!"
      ;;

    *) help ;;

  esac
}

# Help: What are the available methods
function help
{
  style blue
  echo "
branch    all               List all local branches
          go        <name>  Checkout the given branch
          pull              Pull the current branch
          hardpull  <name>  Pull ALL the given branch
          diff              Display all locale changes
          clean             Revert all locale changes
          reset             Revert ALL locale changes
          delete    <name>  Delete the given branch
tag       get               Get the current tag
          all               List all tags
          go        <name>  Checkout the given tag
project   install           Execute scripts/install.sh
          update            Execute scripts/update.sh
          chown     <owner> Change project's owner 
go                  <name>  Go to another project state
ls                  <name>  List all files of the givern folder
clean                       Delete already-merged branches
composer  install           Install packages
          update            Update packages
          list              List installed packages
sh        <path>            Execute the script path
quit                        Quit this script
       "

  ask
}

# How to use this script
function usage
{
  log "error" "Unable to launch the script."
  log "info" "Try this: ./update.sh <project> <state>"
  log "info" "Try this: ./update.sh version"
  log "info" "Try this: ./update.sh update"
  log "warn" "Do not forget to configure your ini file."
  log "warn" "Please restart."
}

function random_phrase
{
  tab=(
    "Normalement, tout y est. Vous voulez compter ?"
    "Puller dans la vie, il n’y a rien de plus vrai."
    "Joyeux anniversaire !"
    "Joyeux Noël !"
    "S’il y a un problème, je crois que c’est la faute de Kevin..."
    "Vous êtes sûr que c’était ce que vous vouliez ?"
    "On va tout casser !!"
    "J’ai l’impression qu’il manque un truc…"
    "Bonjour, moi c'est Otto ! Enchanté de travailler avec vous."
    "Vous et moi, c'est pour la vie ! <3"
    "Attention ceci n'est pas un exercice, je répète, ceci n'est pas..."
    "Ça me fait penser à une histoire marrante tiens ! Qui sait, je vous la raconterai peut-être un jour :)"
    "Je ne suis pas là en ce moment, veuillez laisser un message après le BIP sonore..."
    "Attendez, attendez, on peut le refaire ?"
    "Je pense qu'on est sur la bonne voie !"
    "Hourra ! Allez, ce soir je vous invite au V&B ;-)"
    "En fait, quand je ne parle pas, c'est que je vous étudie en silence."
    "Vous allez bien aujourd'hui ?"
    "LOL"
    "42"
    "Il y a tellement longtemps que je fais ce travail... j'aimerais bien prendre des vacances."
    "Hé, mais c'est vous ! Ça faisait looongtemps !"
    "Chuuut ! Me dérangez pas, j'suis en train de mater le dernier épisode de Twin Peaks là."
    "Naan mais sérieux... vous êtes vraiment développeur ?"
    "Maintenance en cours ! Veuillez ne pas bouger et ne pas cligner des yeux surtout."
    "On dirait que tout a l'air bon ! Champagne ?"
    "Laissez-moi tranquille un peu !"
    "J'aimerais bien me réincarner en intelligence artificielle ! ... Oh Wait !"
    "Dans la vie, il y a des hauts et débats. Vous en pensez quoi ?"
    "Choisissez un nombre entre 0 et 1. Multipliez-le par 2, retranchez 1, vous obtenez votre nombre de départ !"
    "Dites, dites, je pourrais vous spoiler la fin d'une série juste pour le fun ?"
    "Miiince ! On a un problème avec le secteur 5 ! Je sais, on va confiner le secteur 4 pour limiter les dégâts :)"
    "Pain au chocolat ou chocolatine ?"
  )

  length=${#tab[@]}
  index=$(( RANDOM%(length*3) ))
  if [ $index -lt $length ]; then
    log "say" "${tab[index]}"
  fi
}

# Change style of text output
function style
{
  if [[ $1 == 'blue-bold' ]]; then printf '\033[1;34m'; fi
  
  if [[ $1 == 'blue' ]];      then printf '\033[0;34m'; fi
  if [[ $1 == 'red' ]];      then printf '\033[0;31m'; fi
  if [[ $1 == 'cyan' ]];      then printf '\033[0;36m'; fi
  if [[ $1 == 'purple' ]];      then printf '\033[0;35m'; fi
  if [[ $1 == 'green' ]];      then printf '\033[0;32m'; fi
  if [[ $1 == 'yellow' ]];      then printf '\033[0;33m'; fi

  if [[ $1 == 'normal' ]];    then printf '\033[0m'; fi
}

function log
{
  case $1 in 

    info)
      style cyan
      printf "info"
      style normal
      printf ":\t"
      ;;

    warn)
      style yellow
      printf "warn"
      style normal
      printf ":\t"
      ;;

    error)
      style red
      printf "error"
      style normal
      printf ":\t"
      ;;

    say)
      style green
      printf "Otto"
      style normal
      printf ":\t"
      ;;

  esac

  echo "$2"
}

# Get value from INI file
function ini_get
{

    eval `sed -e 's/[[:space:]]*\=[[:space:]]*/=/g' \
        -e 's/;.*$//' \
        -e 's/[[:space:]]*$//' \
        -e 's/^[[:space:]]*//' \
        -e "s/^\(.*\)=\([^\"']*\)$/\1=\"\2\"/" \
    < $INI_FILE \
    | sed -n -e "/^\[$1\]/,/^\s*\[/{/^[^;].*\=.*/p;}"`

    echo ${!2}
}

# THIS NEXT LINE CAN BE MODIFIED
INI_FILE=config.ini

# SOURCE
src=$(pwd)

# GIT PATH
git="https://raw.githubusercontent.com/Menencia/otto/master/"

# VERSION
if [[ -f version.txt ]]; then
  v=$(cat version.txt)
else
  v=""
fi

# UPDATE ?
if [[ $1 = 'update' ]]; then
  read -p "Confirm update ? [y/n]" confirm
  if [[ $confirm = 'y' ]]; then
    curl -# $git"update.sh" > $src/update.sh
    curl -# $git"version.txt" > $src/version.txt
    log "info" "Updated!"
    log "warn" "Please restart."
  else
    log "info" "Not updated!"
    log "warn" "Please restart."
  fi
  exit 0
fi

if [[ $1 = 'version' ]]; then
  version=$(curl -s $git"version.txt")
  log "info" "VERSION $v (Current: $version) by Menencia"
  if [[ $v != $version ]]; then
    log "warn" "Please update this script: ./update.sh update"
  fi
  exit 0
fi

# PATH
project=$1
state=$2
path=$(ini_get $1 $2)

# GO
if [[ -d $path && $# = 2 ]]; then
# Main informations
  log "info" "SRC: $src"
  log "info" "PATH: $path"
  cd $path
  autocomplete
  ask
else
  usage
  exit 0
fi
