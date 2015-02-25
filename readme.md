# Update a git repo

With this script, you can easily update a git repo.

## Install

```
curl -# https://raw.githubusercontent.com/Menencia/otto/master/update.sh > update.sh
curl -# https://raw.githubusercontent.com/Menencia/otto/master/version.sh > version.sh
```

## Ini file sample

```
[project]
state1=/var/www/project/state1
state2=/var/www/project/state2
```

## How to launch it

```
./update.sh <project> <state>     How to launch it
./update.sh version               Current version
./update.sh update                Update this script

DON'T FORGET TO CONFIGURE YOUR INI FILE ("$INI_FILE").
```

## What are the available methods

```
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
composer  install           Install/update packages
          list              List installed packages
sh        <path>            Execute the script path (without .sh)
quit                        Quit this script
```

## License

           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                   Version 2, December 2004
 
        Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
 
        Everyone is permitted to copy and distribute verbatim or modified
        copies of this license document, and changing it is allowed as long
        as the name is changed.
 
           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
          TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
 
         0. You just DO WHAT THE FUCK YOU WANT TO.
