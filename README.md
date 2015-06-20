ps1gen
======
ps1gen generates a command prompt for ksh93 or bash with the following features:
* colorized current working directory.
* current git branch, if in a git repo.
* exit status in red of last executerd command, if non-zero.

Setup
* You need to source ps1gen.sh to install the function 'ps1gen'.
* Add this to .profile, .bashrc and/or .kshrc:
*  . ps1gen.sh               # install functions
*  export PS1="\`ps1gen\`"   # use ps1gen function to generate prompt

Examples:
* Git repo branch:
*   ~/src/vim{master}$ 
* Non-zero exit status:
*   ~$ xyz
*   -bash: xyz: command not found
*   ~127$ 

Enjoy.
* -Paul Lampert
