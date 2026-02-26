# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
   . /etc/bashrc
fi

if [ -z "$PS1" ]; then
   return
fi

# Get the OS.  Used for OS-specific settings (Darwin vs Linux)
OS=$(uname)

# Turn on fancy echo printing and dir correction for cd
shopt -s xpg_echo cdable_vars cdspell autocd

# Don't wait for job termination notification
set -o notify

# Don't use ^D to exit
# set -o ignoreeof

# Exports for PATH and bash completion.  
# Mostly to accomodate Homebrew on different Mac hardware
#
# FIXME: Linux and Homebrew on Intel use /usr/local/bin at the
#        beginning of PATH; however, the line is redundant.
#
if [[ "$OS" == "Darwin" ]]
then
   if [[ "$(uname -m)" == "arm64" ]]
   then
      export PATH="/usr/local/bin:/opt/homebrew/bin:$PATH"
      # Enable bash competion (from HomeBrew)
      if [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]]
      then
          . "/opt/homebrew/etc/profile.d/bash_completion.sh"
      fi
   else
      export PATH=/usr/local/bin:$PATH
      # Enable bash competion (non-HomeBrew)
      [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
   fi
else
    # Linux
    [[ -r "/etc/profile.d/bash_completion.sh" ]] && . /etc/profile.d/bash_completion.sh
fi

export EDITOR=vim                         \
       HISTCONTROL="ignoreboth:erasedups" \
       HISTTIMEFORMAT="[%D %T] "          \
       LC_COLLATE=C                       \
       LESS="-FRX"                        \
       LUA_INIT=@/$HOME/devel/lua/rc.lua

# Directory colorization
if [[ "$OS" == "Darwin" ]]
then
   # export LSCOLORS="GxfxcxdxCxegedabagacad"
   echo "export LSCOLORS=\"GxfxcxdxCxegedabagacad\"" >~/.ls_colors
else
   DIRCOLORS="$HOME/.dircolors"
   [[ ! -f ~/.ls_colors ]] &&  dircolors $DIRCOLORS >~/.ls_colors
fi

. ~/.ls_colors

# export PATH="/opt/homebrew/bin:/usr/local/bin:/bin:/usr/sbin:/sbin:/usr/bin"
# export MANPATH=/usr/local/man:/usr/local/share/man:/usr/share/man
# export MANPATH=/usr/share/man:/usr/local/man:/usr/local/share/man
# export PATH="$PATH:/usr/local/bin:/bin:/usr/sbin:/sbin:/usr/bin"

####################################
#    Git and iTerm-related stuff 
#
[[ -f ~/.iterm2_shell_integration.bash ]] && source ~/.iterm2_shell_integration.bash
[[ -f ~/.git-completion.bash ]] && source ~/.git-completion.sh
[[ -f ~/.git-prompt.sh ]] && source ~/.git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1

# Color definitions (raw)
#  _bold='\[\033[1m\]'             # bold
#   _red='\[\033[1;31m\]'          # RED
#   _grn='\[\033[1;32m\]'          # GREEN
#   _yel='\[\033[1;33m\]'          # Yellow
#   _mag='\[\033[1;35m\]'          # Magenta
#   _wht='\[\033[1;37m\]'          # Bright White
#   _wor='\[\033[41;37m\]'         # White on Red
#   _nrm='\[\033[0;39m\]'          # No color

# FIXME: Source ~/.colors from dotfiles
# Colors (used in PS1) - Bright
bold="\[\e[1m\]"         # White
 red="\[\e[1;31m\]"      # Red
 grn="\[\e[0;32m\]"      # Green
 yel="\[\e[1;33m\]"      # Yellow
 mag="\[\e[1;35m\]"      # Magenta
blue="\[\e[1;34m\]"      # Blue
 wht="\[\e[1;37m\]"      # Bright White
 wor="\[\e[41;37m\]"     # White on Red
nrm="\[\e[0m\]"         # No color

# export PS1="${bold}[${red}\u ${rset}${yel}\W${rset}${bold}]$ ${rset}"
export PS1="${bold}[${red}\u@\h${mag}\$(__git_ps1) ${nrm}${yel}\W${nrm}${bold}]$ ${nrm}"
# export PS1="\[\e[1m\][\[\e[1;31m\]\u \$(__git_ps1)\[\e[0m\e[1;33m\]\W\[\e[0m\e[1m\]]$ \[\e[0m\]"

# if [[ ! -f ~/.ls_colors ]]
# then
#    [[ -f ~/.dircolors ]] && dircolors -b ~/.dircolors >.ls_colors
# fi

#
# User specific aliases and functions
#
# TODO: Separate os-specific aliases (Darwin vs Linux)
#

# alias batlvl='printf "Charge Level: %d%%" $(system_profiler SPPowerDataType | grep "State of Charge" | cut -d: -f2)'
alias ctt='echo -ne "\033]1;\007"'
alias cwt='echo -ne "\033]0;\007"'
alias grep="grep --color=auto"
[[ ! -z "$(which minipro 2>/dev/null)" ]] && alias eeprom="minipro -p AT28C256 -w $1"
alias fgcol='for ((x=0; x<=255; x++));do echo -e "${x}:\033[38;5;${x}mcolor\033[000m";done'
alias bgcol='for ((x=0; x<=255; x++));do echo -e "${x}:\033[48;5;${x}mcolor\033[000m";done'
alias funcs='declare -F | grep -v "_"'
alias killswp='find  . -name .*.swp -exec rm {} \;'
[[ "$OS" == "Darwin" ]] && alias ls='ls -G'
[[ "$OS" == "Linux" ]] && alias ls='ls --color=tty'
alias myip='curl -s https://postman-echo.com/ip | jq .ip | tr -d "\""'
alias newbash="sed -e 's/^#\!.*$/#\!\/usr\/bin\/env bash/' -i '' $*"
[[ "$OS" == "Darwin" ]] && alias preview='open -a preview $*'
[[ "$OS" == "Darwin" ]] && alias proctemp='sudo powermetrics --samplers smc |grep -i "CPU die temperature"'
alias smbcbm='mount_smbfs //don:skynyrd@scooter/pub/CBM ~/Scooter/pub/CBM'
alias smbhome='mount_smbfs //don:skynyrd@scooter/homes ~/Scooter/homes'
alias smbpub='mount_smbfs //don:skynyrd@scooter/pub ~/Scooter/pub'
[[ "$OS" == "Darwin" ]] && alias updatedb='sudo /usr/libexec/locate.updatedb'
alias updatepip='pip list --outdated | tail -n +3 | cut -d" " -f1 | xargs -n1 pip install -U'
alias vi='vim'
alias vihosts="sudo vi /etc/hosts"
# MacOS doesn't allow symlinks in /usr/share/vim, so this kludge
vimdir=$(basename $(ls -d /usr/share/vim/vim[0-9]*))
alias vless='/usr/share/vim/$vimdir/macros/less.sh'
alias vless-a65='/usr/share/vim/$vimdir/macros/less.sh -c ":set syntax=a65"'
alias vless-fasm='/usr/share/vim/$vimdir/macros/less.sh -c ":set syntax=fasm $*"'
alias xssh='ssh -o forwardx11=yes'

# ,---------------.
# |               |
# |  Funcitons    |
# |               |
# `---------------.

if [[ "$OS" == "Darwin" ]]
then
   function allbrew() {
       brew formulae | grep "$1" | pr -4 -t
   }

   function batlvl() {
     charge="$(system_profiler SPPowerDataType | grep "State" | cut -d: -f2)"
     printf "Charge Level: %d%%" $charge
   }
fi

if [[ ! -z "$(which bat 2>/dev/null)" ]]
then
   bathelp () {
      "$@" --help 2>&1 | bat --plain --language=help
   }
fi

if [[ ! -z "$(which c1541 2>/dev/null)" ]]
then
   cbmdir() {
      if [[ -z "$1" ]]
      then
         echo "Disk not specified.";
      else
         oldIFS="$IFS"
         IFS='
'
         c1541 "$1" -list
         IFS="$oldIFS"
      fi
   }
fi

dec() {
    printf '%d\n' 0x$1
}

detab() {
   tmpfile=tmp$$
   perm=$(stat -f '%p' $1 | cut -c4-)
   cat $1 | sed -e 's/	/        /g' >tmp$$
   mv tmp$$ $1
   chmod $perm $1
}

dirsize() {
   for d in $(find [A-z]* -type d -maxdepth 0)
   do
       du -sh $d
   done
}

if [[ $(uname) == "Linux" ]]
then
   dircols() {
      dircolors -b ~/.dircolors >~/.ls_colors
      . ~/.ls_colors
   }
   dupedisk() {
      if [[ $# -ne 2 ]]
      then
         echo "Usage: dupedisk src-disk dst-disk"
      else
         sfdisk -d $1 | sed -e 's:$1:$2:g' | sfdisk $2
      fi
   }
fi

if [[ $(uname) == "Darwin" ]]
then
    function eject() {
        dev=$(df | grep "$*" | tail -n 1 | cut -d ' ' -f1)
        diskutil eject $dev
    }
fi

epath() {
   echo $PATH | tr ':' '\n' > ~/.epath
   vi +1 ~/.epath
   export PATH=$(cat ~/.epath | tr '\n' ':' | sed -e 's/:$//g')
   echo $PATH
   rm ~/.epath
}

ethcode() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: ethcode [mac-address | mac-prefix]";
    else
        mac=$1;
        echo "Getting vendor info for $mac...\c";
        vendor="$(curl -s https://api.macvendors.com/${mac})";
        echo "Done.";
        [[ -z "$vendor" ]] && vendor="Not found";
        echo "\nMAC:  $mac: ";
        echo "Vendor: $vendor";
    fi
}

# Darwin
if [[ "$OS" == "Darwin" ]]
then
   function fix() {
      case $1 in
          "ql"|"quicklook")
              svcName="QuickLookUIService"
              ;;
          "siri"|"esc")
              svcName="SiriNCService"
              ;;
          *)
              echo "${FUNCNAME}: usage: fix [ ql | siri ]"
              return
              ;;
      esac
      echo "Fixing $svcName..."
      if [[ -z "$(which pidof)" ]]
      then
          pidlist="$(ps -aef | grep -i $svcName | grep -v grep | awk ' {FS=" "} {ORS=" "} {print $2}')"
      else
          pidlist="$(pidof $srvName)"
      fi
   
      for pid in $pidlist
      do
         echo "Killing PID: $pid"
         kill -9 $pid
      done
   }
fi

funcdef() {
   declare -F $1 >/dev/null 2>&1
   [[ $? -ne 0 ]] && { echo "$1 is not a function"; return; }

   cmd="declare -f $1 "
   which bat 2>/dev/null
   [[ $? -eq 0 ]] && cmd="$cmd | bat -l bash"
   eval $cmd
}

fwip() {
   IFS='
'

   fw_wan="$(ssh home-pfsense ifconfig re0 | grep 'inet ')"
   echo $fw_wan | grep "inet " >/dev/null 2>&1
   if [[ $? -ne 0 ]]
   then
      echo "WAN IP not assigned"
      exit
   fi

   wan_ip=$(echo $fw_wan | cut -d' ' -f2)
   echo "WAN IP: $wan_ip"
}

getfunc() {
   if [[ $# -eq 0 || $# -gt 2 ]]
   then
      echo "Usage: getfunc function-name [ filename ]"
      return
   fi

   which bat >/dev/null 2>&1
   [[ $? -eq 0 ]] && bat=" | bat -l bash"

   if [[ $# -eq 1 ]]
   then
      if [[ -z "$(declare -F $1)" ]]
      then
         echo "$1 not found in environment"
      else
         cmd="declare -f $1 ${bat}"
         eval $cmd
      fi
      return
   else
      fnName=$1; fname=$2
      fn=$(grep -E "^[[:space:]]*(function[[:space:]]+)?${fnName}+[[:space:]]*\(\)" $fname)
      [[ -z "$fn" ]] && { echo "$fnName not found in $fname"; return; }
      fnBeg=$(grep -n "$fn" $fname | grep -v '#' | cut -d':' -f1)
      fnEnd=$(tail -n +$fnBeg $fname | grep -n -m 1 -E '^[[:space:]]*}' | cut -d: -f1)
      numlines=$((fnBeg + fnEnd -1))
      cmd="sed -n '${fnBeg},${numlines}p' $fname ${bat}"
      eval $cmd
   fi
}

getpage() {
   if [[ -z "$1" ]]
   then
      echo "USAGE: getpage url-to-get"
   else
      # lynx -dump -nolist $1
      lynx -dump $1
   fi
}

getmac() {
   for i in $*
   do
#       echo "$i: $(ifconfig $i | tail +2 | tr -s [:space:]| cut -d' '  -f 2)"
       echo "$i: $(ifconfig $i | grep ether | tr -s [:space:] | cut -d' ' -f2)"
   done
}

grps() {
   OS=$(uname -s)
   case $OS in
       "Linux")
           id $1 | sed -e 's/,/\n/g' | sed 's/.*(\(.*\))/\1/' ;;
       "Darwin")
           id $1 | sed -e 's/,/\'$'\n/g' | sed 's/.*(\(.*\))/\1/' ;;
       *) echo "Unknown OS ($OS)"
   esac
}

hex() {
   printf "%x\n" $1
}

ipowner() {
   if [[ -z "$1" ]]
   then
      echo "No IP range specified"
   else
      flist="NetRange|CIDR|Organization|Address|City|StateProv|PostalCode|Country"
      whois $1 | egrep -e "$flist"
   fi
}

pwdb() {
    pushd ~/devel/Python/pw-mgr >/dev/null
    cp work.db work.save
    sqlite3 work.db
    base64 -b 80 -i work.db >work.db.b64
    popd >/dev/null
}

sdig() {
   echo -e "\n$(dig +noquestion +noauthority +noadditional +nostats +nocomments +nocmd $*)\n";
}

subs() {
   local yel="\e[1;33m"
   local rset="\e[0m"
   dir="${1:-.}"
   echo "${yel}\c"
   find -L $dir -maxdepth 1 -type d | sed -e 's:^\.\/::g' | sort -f
   echo "${rset}"
}

swt() {
   title="$*"
   [[ -z "$title" ]] && title="Terminal"
   echo -ne "\033]0;$title\007"
}

tolower () { 
    [[ $# -eq 0 ]] && { echo "Usage: tolower <filename(s)>"; return; }
    for i in $*;
    do
        if [[ ! -e $i ]]
        then
           echo "$i does not exist"
        else
           mv -v $i $(echo $i | tr [:upper:] [:lower:]);
        fi
    done
}

toupper() {
   [[ $# -eq 0 ]] && { echo "Usage: tolower <filename(s)>"; return; }
      for i in $*
      do
          if [[ ! -f $i ]];
          then
              echo "$i does not exist"
          else
             mv -v $i $(echo $i | tr '[:lower:]' '[:upper:]')
          fi
      done
}

rmloc() {
    dd="$(date -r $1 +'%Y%m%d%H%M.%S')";
    sed -i.bak -e '/Location:/d' $1;
    touch -t $dd $1
    rm $1.bak
}

rpmkey() {
    rpm -qp $1 --qf '%{NAME}-%{VERSION}-%{RELEASE} %{SIGPGP:pgpsig} %{SIGGPG:pgpsig}\n'
}

# Upate NIC type on MacOS
if [[ "$OS" == "Darwin" ]]
then
   vmnic() {
      declare -a contype
      contype=("none"
               "null"
               "nat"
               "natnetwork"
               "bridged"
               "intnet"
               "hostonly"
              )
   
      if [[ "$1" == "--help" ||  $# -ne 2 ]]
      then
         echo "\nUsage: vmnic <vm-name> <connection-type>\n"
         echo "Valid connection types:\n\t\c"
         echo ${contype[@]} | sed -e 's/ /\n\t/g'
         return
      fi
   
      vm=$1
      parm="${2:-nil}"
   
      if [[ $(echo ${contype[@]} | grep $parm) ]]
      then
          vboxmanage modifyvm "Oracle Linux 9.6" --nic1=$parm
      else
          echo "Invalid mode: $parm"
      fi
   }
fi

watchfile() { 
   IFS='
'
   tput clear
#   opt="-ld"
   fname=$*
   
   [[ -z "$fname" ]] && fname="*"
#   [[ "$1" == "-h" ]] && opt="-ldh"
   while [ 1 ]
   do
      tput home
      echo -e "\n"
      ls -ld  $fname | tr -s [:space:] | cut -d' ' -f5,9
      ls -ldh $fname | tr -s [:space:] | cut -d' ' -f5,9
#      sleep 1
   done
}

watchit () {
    watch -n 0 "ls -l $1; ls -lh $1"
}
