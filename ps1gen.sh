# ps1gen
# ======
# ps1gen generates a command prompt for ksh93 or bash with the following features:
# * colorized current working directory.
# * current git branch, if in a git repo.
# * exit status in red of last executerd command, if non-zero.
# 
# Setup
# * You need to source ps1gen.sh to install the function 'ps1gen'.
# * Add this to .profile, .bashrc and/or .kshrc:
# *  . ps1gen.sh               # install functions
# *  export PS1="\`ps1gen\`"   # use ps1gen function to generate prompt
# 
# Examples:
# * Git repo branch:
# *   ~/src/vim{master}$ 
# * Non-zero exit status:
# *   ~$ xyz
# *   -bash: xyz: command not found
# *   ~127$ 
# 
# Enjoy.
# * -Paul Lampert

# Set any of these variables in .profile before ps1gen.sh to customize:
#  PS1GEN_EXIT_STATUS_COLOR=196    # red
#  PS1GEN_GIT_BRANCH_COLOR=10      # green
#  PS1GEN_GIT_TAG_COLOR=11         # yellow
#  PS1GEN_GIT_INCLUDE_HOME=0       # 1=show git branch in $HOME directory
#  PS1GEN_CWD_COLOR=7              # white
#  PS1GEN_TEXT_COLOR=208           # amber
#  PS1GEN_PROMPT="$ "              # default prompt, $

function ps1gen
{
    typeset rc=$?
    if [[ $rc -eq 0 ]]; then
        typeset r=
    else
        typeset r="`ps1gen_set_fg ${PS1GEN_EXIT_STATUS_COLOR:-196}`$rc"
    fi
    typeset b=
    typeset branch=
    # find .git dir
    typeset lastinode=-1
    typeset dir="$PWD"
    typeset b=
    typeset its=0
    while true;do
        its=$((its+1))
        if [[ $its -gt 50 ]]; then
            echo >&2 "ps1gen: too many levels $its"
            break
        fi
        if [[ -d $dir/.git ]];then
            # found!
            read branch < $dir/.git/HEAD
            if [[ $branch = ref:* ]];then
                branch=${branch##*/}
                b="`ps1gen_set_fg ${PS1GEN_GIT_BRANCH_COLOR:-10}`{$branch}"
                if [[ ${PS1GEN_GIT_INCLUDE_HOME:-0} -eq 0 ]]; then
                  if [[ $branch = master ]]; then
                      if [[ $HOME/.git/config -ef $dir/.git/config ]]
                      then
                          unset b # don't show master branch, when in home dir
                      fi
                  fi
                fi
            else
                b="`ps1gen_set_fg ${PS1GEN_GIT_BRANCH_COLOR:-10}`{$branch}"
                # check for tags
                tdir=$dir/.git/refs/tags
                ls -t $tdir | while read tagfiles
                do
                    read tag < $tdir/$tagfiles
                    if [[ $branch = $tag ]];then
                        branch="tag: $tagfiles"
                        b="`ps1gen_set_fg ${PS1GEN_GIT_TAG_COLOR:-11}`{$branch}"
                        break
                    fi
                done
            fi
            break
        fi
        ndir="${dir%/*}"
        [[ $ndir = $dir ]] && break
        dir="$ndir"
    done
    typeset p=${PWD}
    if [[ $p = ${HOME} || $p = ${HOME}/* ]];then
        p="~${p##$HOME}"
    fi
    echo "`ps1gen_set_fg ${PS1GEN_CWD_COLOR:-7}`$p$b$r`ps1gen_set_fg ${PS1GEN_TEXT_COLOR:-208}`${PS1GEN_PROMPT:-\$ }"
}

ps1gen_set_fg()
{
    printf "\e[38;5;${1}m"
}
