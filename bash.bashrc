# System-wide .bashrc file for interactive bash(1) shells.
. /usr/share/autojump/autojump.sh #autojump
# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

##History
export HISTTIMEFORMAT='%F %T '
export HISTCONTROL=ignoredups
export HISTCONTROL=ignorespace
alias rmhist="history -c"mobi
alias anonhist="export HISTSIZE=0"
alias hist="export HISTSIZE=1"

##Colors
color_def="~/.colorrc"
 
if [[ -f $color_def ]]; then
   . $color_def
else
   # color definitions
   black="$(tput setaf 0)"
   darkgrey="$(tput bold ; tput setaf 0)"
   lightgrey="$(tput setaf 7)"
   white="$(tput bold ; tput setaf 7)"
   red="$(tput bold ; tput setaf 1)"
   lightred="$(tput setaf 1)"
   green="$(tput bold ; tput setaf 2)"
   lightgreen="$( tput setaf 2)"
   yellow="$(tput setaf 3)"
   blue="$(tput bold ;tput setaf 4)"
   lightblue="$(tput setaf 4)"
   purple="$(tput bold ;tput setaf 5)"
   pink="$(tput setaf 5)"
   cyan="$(tput bold ;tput setaf 6)"
   lightcyan="$(tput setaf 6)"
   nc="$(tput sgr0)" # no color
fi
export darkgrey lightgreywhite red lightred green lightgreen yellow blue
export lightblue purple pink cyan lightcyan nc
if [[ ! $level_color ]]; then
   level_color=$cyan
fi
if [[ ! $script_color ]]; then
   script_color=$yellow
fi
if [[ ! $linenum_color ]]; then
   linenum_color=$red
fi
if [[ ! $funcname_color ]]; then
   funcname_color=$green
fi
if [[ ! $command_color ]]; then
   command_color=$white
fi
export script_color linenum_color funcname_color
 
reset_screen() {
 
   echo $nc
}
reset_screen
 
usage()
{

cat <<EOF
Default colors are:
${level_color}- shell level color:cyan$nc
${script_color}- script name: yellow$nc
${linenum_color}- line number: red$nc
${funcname_color}- function name: green$nc
${command_color}- command executed: white$nc
- Other colors options are: ${darkgrey}darkgrey$nc, ${lightgrey}light grey$nc, ${lightred}light red,${lightgreen}light green, ${blue}blue, ${lightblue}light blue, ${purple}purple, ${pink}pink, ${lightcyan}light cyan$nc.

Usage: debug 
- help|usage: print this screen
- verbose: sets -xv flags
- noexec: sets -xvn flags
- no parameter sets -x flags
 
${script_color} coding for good - node command line $nc 
${command_color} Ƀe ℋuman, be κinđ, be ωise $nc

EOF
}
 
 
debug_cmd()
{
   trap reset_screen INT
   /bin/bash $FLAGS $SCRIPT
}
 
if [ $# -gt 0 ]; then
   case "$1" in
         "verbose")
            FLAGS=-xv
            SCRIPT=$2
         ;;
         "noexec")
            FLAGS=-xvn
            SCRIPT=$2
         ;;
         "help"|"usage")
            usage
            exit 3
         ;;
         *)
            FLAGS=-x
            PS4="${level_color}+${script_color}"'(${BASH_SOURCE##*/}:${linenum_color}${LINENO}${script_color}):'" ${funcname_color}"
            export PS4
            SCRIPT=$1
         ;;
   esac
   debug_cmd
else
   usage
fi

gpgverify() {
echo "FIRST. IMPORT THE SERVER KEY. COPY AND PASTE SOMETHING LIKE gpg --keyserver pool.sks-keyservers.net --recv-keys 0x427F11FD0FAA4B080123F01CDDFA1A3E36879494"
read command
$command
gpg --import ./**.asc
echo "introduce un valor 0x para gpg --edit-key 0x36879494 and then, in order to ultimately trust it, introduce: fpr / trust / 5 / y / q "
read masterkey
gpg --edit-key $masterkey -c "fpr && trust && 5 && y && q"
gpg -v --verify **.asc **.iso
gpg -v --verify **.DIGESTS
}

gpgexport() {
read -p "introduce the key username to export" USN
gpg --export -a $USN > $USNpublic.key
gpg --export-secret-key -a $USN > $USNprivate.key
gpg --fingerprint > $USNfingerprint
echo "your public key and private have been exported on $USNpublic.key, $USNprivate.key and $USNfingerprint" 
}

gpgimport() {
read -p "introduce the key username to import Usernameprivate.key and/or Usernamepublic.key" USN
gpg --import -a $USN > $USNpublic.key
gpg --import-secret-key -a $USN > $USNprivate.key
echo "your public key and private have been imported as $USNpublic.key and $USNprivate.key" 
}

gpgdelete() {
read -p "introduce the key username to delete Usernameprivate.key and/or Usernamepublic.key" USN
gpg --delete -a $USN > $USNpublic.key
gpg --delete-secret-key -a $USN > $USNprivate.key
echo "your public key and private have been deleted as $USNpublic.key and $USNprivate.key" 
}

gpglist() {
echo "pubkeys list"
gpg --list-keys
echo "privkeys list"
gpg --list-secret-keys
echo "fingerprints"
gpg --fingerprint
}

gpgencrypt() {
read -p "enter your gpg username (sender username)" USNs
read -p "enter your gpg username (receiver username)" USNr
gpg -e -u $USNs -r $USNr somefile
}

gpgdecrypt() {
read -p "enter file.gpg to decrypt" filegpg
gpg -o $filegpg[-4] -d $filegpg
}

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
 force_color_prompt=yes
# set a fancy prompt (non-color, overwrite the one in /etc/profile)
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#    ;;
#*)
#    ;;
#esac

# enable bash completion in interactive shells
#if ! shopt -oq posix; then
#  if [ -f /usr/share/bash-completion/bash_completion ]; then
#    . /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#  fi
#fi

# sudo hint
if [ ! -e "$HOME/.sudo_as_admin_successful" ] && [ ! -e "$HOME/.hushlogin" ] ; then
    case " $(groups) " in *\ admin\ *)
    if [ -x /usr/bin/sudo ]; then
	cat <<-EOF
	To run a command as administrator (user "root"), use "sudo <command>".
	See "man sudo_root" for details.

	EOF
    fi
    esac
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
	function command_not_found_handle {
	        # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
		   /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
		   /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
		else
		   printf "%s: command not found\n" "$1" >&2
		   return 127
		fi
	}
fi

if [ -f /etc/bash_preexec ]; then
    # source preexec and precmd hook functions for Bash
	# If you have anything that's using the Debug Trap or PROMPT_COMMAND
	# change it to use preexec or precmd
	# See also https://github.com/rcaloras/bash-preexec
    . /etc/bash_preexec
fi

## Create a repo on Github (not git)
gitnew() {
 repo_name=$1

 dir_name=`basename $(pwd)`

 if [ "$repo_name" = "" ]; then
 echo "Repo name (hit enter to use '$dir_name')?"
 read repo_name
 fi

 if [ "$repo_name" = "" ]; then
 repo_name=$dir_name
 fi

 username=`git config github.user`
 if [ "$username" = "" ]; then
 echo "Could not find username, run 'git config --global github.user <username>'"
 invalid_credentials=1
 fi

 token=`git config github.token`
 if [ "$token" = "" ]; then
 echo "Could not find token, run 'git config --global github.token <token>'"
 invalid_credentials=1
 fi

 if [ "$invalid_credentials" == "1" ]; then
 return 1
 fi

 echo -n "Creating Github repository '$repo_name' ..."
 curl -u "$username:$token" https://api.github.com/user/repos -d '{"name":"'$repo_name'"}' > /dev/null 2>&1
 echo " done."
}


gitupload () {
  echo "introduce tu email"
  read email
  git config --global user.email $email
  echo "introduce tu username"
  read username
  git config --global user.name $username
  git commit -m "First commit"
  echo "introduce la url del repositorio"
  read url
  git remote add origin $url
  git remote -v
  git pull origin master
  git push origin master
}


securedelete () {
  read -p "DANGER VAS A BORRAR DE FORMA SEGURA TODO. INTRODUCE LA RUTA DE LA CARPETA O EL ARCHIVO SIN EQUIVOCARTE      -->" route
  rin="$route""/**"
  sudo shred -uvzn 3 $route
  sudo shred -uvzn 3 $rin
  sudo srm -vrzd $route
  }

docsthemagic () {
  read -p "vas a crear las copias, luego armonizar los nombres y finalmente limpiar los metadatos de todos los archivos ubicados en esta carpeta. Introduce los documentos. recuerda que si quieres hacer un backup puedes usar mat -b" docs
  sudo unoconv --format=txt $docs
  sudo unoconv --format=pdf $docs
  sudo unoconv --format=doc $docs
  sudo unoconv --format=docx $docs
  sudo unoconv --format=odt $docs
  sudo unoconv --format=html $docs
  sudo pandoc -f html -t markdown -o $docs+".md" $docs
  sudo detox -r **
  for file in *.html.pdf; do
    sudo mv "$file" "`basename $file .html.pdf`.pdf"
    done
  for file in *.html.epub; do
    sudo mv "$file" "`basename $file .html.pdf`.epub"
    done
  for file in *.html.wiki; do
    sudo mv "$file" "`basename $file .html.wiki`.wiki"
    done
  for file in *.html.txt; do
    sudo mv "$file" "`basename $file .html.txt`.txt"
    done
 for file in *.html.md; do
    sudo mv "$file" "`basename $file .html.md`.md"
    done
  for file in *.html.odt; do
    sudo mv "$file" "`basename $file .html.odt`.odt"
    done
  sudo mat -c **
  sudo mat **
}

updatebash() {
sudo wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/bash.bashrc
sudo rm /etc/bash.bashrc
sudo rm /etc/bash.bashrc~
sudo mv bash.bashrc /etc/bash.bashrc
}

getsh() {
sudo wget https://github.com/abueesp/Scriptnstall/edit/master/reinstall.sh
sudo wget https://github.com/abueesp/Scriptnstall/edit/master/work.sh
sudo wget https://github.com/abueesp/Scriptnstall/blob/master/dnie.sh
}

she() {
echo "Please introduce a word start: "
read W
echo "Please enter the file route: "
read filon
bash <(sed -n '5,$W p' $filon)
}

mysqlconnect(){
echo "introduce usuario"
$sqlu
echo "introduce IP del host o pulsa ENTER si es localhost"
$sqlh
firefox -new-tab https://www.thegeekstuff.com/2010/01/awk-introduction-tutorial-7-awk-print-examples/ && mysql -u $sqlu -p -h $sqlh
}

debugg(){
read -p "insert the name of the file \n" file
sed -i '1i-set' $file
sed -b "\$a-set" $file
}

music(){
read -p "(1) Musicovery (2) Soundcloud (3) EveryNoise (4) Freemp3 (5) Spotify (6) Discogs " music $music
if [ $music = "1" ]; then
  firefox -new-tab https://musicovery.com
elif [ $music = "2" ]; then
  firefox -new-tab https://soundcloud.com/realdoesntmeanroyal
elif [ $music = "3" ]; then
  firefox -new-tab https://everynoise.com
elif [ $music = "4" ]; then
  firefox -new-tab https://my-free-mp3.com
elif [ $music = "5" ]; then
  firefox -new-tab https://play.spotify.com/
elif [ $music = "6" ]; then
  firefox -new-tab https://www.discogs.com/
else
  echo "¡ music & naranjas !"
fi
}


##Monitoring
appmon(){
read -p "introduce el nombre del proceso" app
sudo lsof -i -n -P | grep $app && sudo ps ax
}
alias usermon="sudo users; sudo w; sudo who -a; sudo ipcs -m -c"
alias systemmon="sudo df -h; ipcs -u; sudo ipcs -m -c; sudo service --status-all; sudo htop; sudo w -i; sudo lshw; sudo dmidecode; sudo ps -efH | more; sudo lsof | wc -l; sudo lsof"
alias netmon="sudo vnstat; sudo netstat -ie; sudo netstat -s; sudo sudo netstat -pt; sudo iptables -S; sudo w -i; sudo ipcs -u; sudo tcpdump -i wlan0; sudo iotop; sudo ps; sudo netstat -r; echo 'En router ir a Básica -> Estado -> Listado de equipos'"
alias portmon="sudo nc -l -6 -4 -u; sudo ss -o state established; sudo ss -l; sudo netstat -avnp -ef"


#Aliases
alias Trash="cd .local/share/Trash/files"
alias whoneedssudo="sudo find . -xdev -user root -perm -u+w && echo 'maybe you wanted to add -type and -exec to specify f or d or to execute a command such as chmod, lss or cpc. You can also use -name or -size to specify the name or +100 mb; or -mmin -60 and -atime -1 for modified last hour or accessed last day. You can also use -cmin -60 for files changed last hour or -newer FILE for those modified after FILE or -anewer/-cnewer FILE if accessed/changed'"
alias calc="let calc"
alias skill="sudo kill -9"
alias wline="sudo grep -n"
alias nmapp="sudo nmap -v -A --reason -O -sV -PO -sU -sX -f -PN --spoof-mac 0"
alias nmap100="sudo nmap -F -v -A --reason -O -sV -PO -sU -sX -f -PN --spoof-mac 0"
alias lss="ls -ld && sudo du -sh && ls -i1 -latr -lSr -FGAhp --color=auto -t -a -al"  # lSr sort by size ltr sort by date
alias lk='ls -lSr --color=auto -FGAhp'        # lSr sort by size ltr sort by date
alias lsall='ls -ld && sudo du -sh && ls -i1 -latr -lSr -FGAhp --color=auto -t -a -al -lR'        # recursive ls
alias verifykey="gpg --keyid-format long --import"
alias verifyfile="gpg --keyid-format long --verify"
alias secfirefox="firejail --dns=8.8.8.8 --dns=8.8.4.4 firefox"
alias lssh="ls -al ~/.ssh"
alias dt='date "+%F %T"'
alias pdf2txt='ls * | sudo xargs -n1 pdftotext'
alias bashrc='/etc/bash.bashrc'
alias geditbash='sudo gedit /etc/bash.bashrc'
alias vimbash='sudo vim /etc/bash.bashrc'
alias atombash='sudo atom /etc/bash.bashrc'
alias nanobash='sudo nano /etc/bash.bashrc'
alias myip="dig +short http://myip.opendns.com @http://resolver1.opendns.com"
alias cpc='cp -i -r'
alias mvm='mv -i -u'
alias rmr='sudo rm -irv -rf'
alias delete=rmr
alias remove=rmr
alias keepasss="sudo mono /home/$USER/KeePass/KeePass.exe"
alias keepass="mono /home/$USER/KeePass/KeePass.exe"
alias df='df -h'
alias aptup='sudo apt-get update && sudo apt-get upgrade && sudo apt-get clean'
alias mkdirr='mkdir -p -v'
alias downweb='wget --mirror -p --convert-links -P .'
alias lvim="vim -c \"normal '0\"" # open vim editor with last edited file
alias grepp='grep --color=auto -r -H'
alias egrepp='egrep --color=auto -r -w'
alias fgrepp='fgrep --color=auto'
alias aptclean='sudo apt-get autoremove'
alias rename='mv'
alias gitlist='git remote -v'
alias gethlocal="geth --rpc --rpccorsdomain localhost --etherbase '0x9B366b5493a545f070E4a0F16c81182670fEE6' --solc console"
alias gethmine='geth --etherbase '0x9B366b5493a545f070E4a0F16c81182670fEE6' --mine --minergpus --autodag --minerthreads "8" console'
alias gethtest="geth --testnet console"
alias gethupgrade="geth upgradedb --fast console"
alias adbconnect="mtpfs -o allow_other /mnt/mobile"
alias adbdisconnect="fusermount -u /mnt/mobile"
alias newgpgkey="gpg --gen-key"

### Some cheatsheets###
alias mobilesheet="firefox -new-tab http://www.movilzona.es/tutoriales/android/root/principales-comandos-para-adb-y-fastboot-guia-basica/"
alias emacssheet="firefox -new-tab https://www.emacswiki.org/ && firefox -new-tab http://www.ling.ohio-state.edu/~kyoon/tts/unix-help/LaTeX/emacs-cheatsheet-2-of-2.jpg && firefox -new-tab http://www.muylinux.com/wp-content/uploads/2010/11/Emacs-Cheatsheet-wallpaper.jpg && firefox -new-tab https://github.com/emacs-tw/awesome-emacs#markdown && firefox -new-tab http://es.tldp.org/Tutoriales/doc-tutorial-emacs/intro_emacs.pdf"
alias electrumsheet="firefox -new-tab https://docs.electrum.org/en/latest/"
alias shsheet="firefox -new-tab https://www.tldp.org/LDP/abs/html/index.html" 
alias gethsheet="https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options"
alias gpgsheet="firefox -new-tab http://irtfweb.ifa.hawaii.edu/~lockhart/gpg/gpg-cs.html"
alias bitcoinsheet="firefox -new-tab  https://en.bitcoin.it/wiki/Script#Words"
alias dockersheet="firefox -new-tab  https://www.cheatography.com/storage/thumb/aabs_docker-and-friends.600.jpg && firefox -new-tab https://container-solutions.com/content/uploads/2015/06/15.06.15_DockerCheatSheet_A2.pdf"
alias nmapsheet="firefox -new-tab  https://4.bp.blogspot.com/-lCguW2iNKi4/UgmjCu1UNfI/AAAAAAAABuI/35Px0VIOuIg/s1600/Screen+Shot+2556-08-13+at+10.06.38+AM.png"
alias gitsheet="firefox -new-tab  https://developer.exoplatform.org/docs/scm/git/cheatsheet/ && firefox -new-tab https://github.com/tiimgreen/github-cheat-sheet && echo 'Warning: Never git add, commit, or push sensitive information to a remote repository. Sensitive information can include, but is not limited to:
    Passwords
    SSH keys
    AWS access keys
    API keys
    Credit card numbers
    PIN numbers'"
alias ubuntusheet="firefox -new-tab  https://slashbox.org/index.php/Ubuntu#Cheat_Sheet && firefox -new-tab https://slashbox.org/index.php/Ubuntu#Cheat_Sheet" 
alias vimsheet="firefox -new-tab  https://michael.peopleofhonoronly.com/vim/vim_cheat_sheet_for_programmers_screen.png && firefox -new-tab https://cdn.shopify.com/s/files/1/0165/4168/files/digital-preview-letter.png && firefox -new-tab https://michael.peopleofhonoronly.com/vim/vim_cheat_sheet_for_programmers_screen.png && firefox -new-tab https://cdn.shopify.com/s/files/1/0165/4168/files/digital-preview-letter.png'"
alias wgetsheet="firefox -new-tab https://www.thegeekstuff.com/2009/09/the-ultimate-wget-download-guide-with-15-awesome-examples/"

### Functions ###

free(){
  sudo chmod 777 $1 $2
}

install(){
  sudo apt-get install -y $1
}

uninstall(){
  sudo apt-get remove --purge -y $1
}

mysshkey(){
sudo chown -R $USER:$USER ~/.ssh
sudo chmod -R 755 ~/.ssh
sudo chmod +x ~/.ssh 
sudo apt-get install xclip
sudo xclip -sel clip ~/.ssh/id_rsa/id_rsa.pub
echo 'those are your keys up to now, id_rsa.pub is the default. If you want to change it, type switchmyssh'
sudo ls -al -R ~/.ssh/id_rsa
echo "Now you may have your ssh key on your clipboard. If you have already set your app global configuration, now you should go to Settings -> New SSH key and paste it there"
sudo chmod -R 600 ~/.ssh
}

mylastsshkey(){
sudo chown -R $USER:$USER ~/.ssh
sudo chmod -R 755 ~/.ssh
sudo apt-get install xclip
sudo chmod +x ~/.ssh  
read -p "Introduce the ssh last key number (0 is the first)" numerossh 
xclip -sel clip < ~/.ssh/lastid_rsa$numerossh.pub
echo 'this is your last key, lastid_rsa'$numerossh'.pub is the default.'
ls -al -R ~/.ssh
echo "Now you may have your last ssh key on your clipboard. If you have already set your app global configuration, now you should go to Settings -> New SSH key and paste it there"
sudo chmod -R 600 ~/.ssh
}

switchsshkey(){
sudo chown -R $USER:$USER ~/.ssh
sudo chmod -R 755 ~/.ssh
sudo chmod +x ~/.ssh
numberssh = 0
if [$1]
    then
    while [ ! -f lastid_rsa$numberssh ] ;
        do
             numberssh++
        done
    while [ ! -f lastid_rsa$numberssh ] ;
        do
             numberssh1 = $numberssh+1
             sudo mv ~/.ssh/$1 ~/.ssh/lastid_rsa$numberssh ~/.ssh/lastid_rsa$numberssh1
             sudo mv ~/.ssh/$1 ~/.ssh/lastid_rsa$numberssh.pub ~/.ssh/lastid_rsa$numberssh1.pub
             numberssh--
        done 
    sudo mv ~/.ssh/$1 ~/.ssh/id_rsa ~/.ssh/lastid_rsa0
    sudo mv ~/.ssh/$1 ~/.ssh/id_rsa.pub ~/.ssh/lastid_rsa0.pub
    echo "Your last key is now lastid_rsa (priv) and lastid_rsa0.pub (pub). If you want to copy the new one type mysshkey. If you want to copy the last one type mylastsshkey"
    else
    ls -al -R ~/.ssh
    echo "Please, introduce the key you want to switch by the default id_rsa.pub. Those are your current keys: "
fi
sudo chmod -R 600 ~/.ssh
}


newsshkey(){
sudo chown -R $USER:$USER ~/.ssh
sudo chmod -R 755 ~/.ssh
sudo chmod +x ~/.ssh 
$emai = emai
sudo mkdir ~/.ssh
sudo mkdir ~/.ssh/id_rsa
echo 'those are your keys up to now'
sudo ls -al -R ~/.ssh # Lists the files in your .ssh directory, if they exist
echo "Please, introduce 'youremail@server.com'"
read emai
echo "please introduce this /home/node/.ssh/id_rsa/id_rsa as file, OTHERWISE YOU WONT BE ABLE TO USE MYSSHKEY AND THE REST OF SSH MANAGEMENT COMMANDS, and a password longer or equal to 5 caractheres"
ssh-keygen -t rsa -b 4096 -C $emai
eval "$(ssh-agent -s)" 
sudo ssh-add ~/.ssh/id_rsa.pub
sudo chmod -R 600 ~/.ssh
}

# mkmv - creates a new directory and moves the file into it, in 1 step
# Usage: mkmv <file> <directory>
mkmv() {
  mkdir "$2"
  mv "$1" "$2"
}

### Bash Completion ###
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

commit() {
  git add $1 && git commit -m $2 && git push origin $3
}

#la is the new cd + ls
alias la='ls -lah $LS_COLOR'
function cl(){ cd "$@" && la; }
alias back="cd .."
function cdn(){ for i in `seq $1`; do cd ..; done;}


### Extract Archives ###
extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjvf $1    ;;
      *.tar.gz)    tar xzvf $1    ;;
      *.bz2)       bzip2 -d $1    ;;
      *.rar)       unrar2dir $1    ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1    ;;
      *.tgz)       tar xzf $1    ;;
      *.zip)       unzip2dir $1     ;;
      *.Z)         uncompress $1    ;;
      *.7z)        7z x $1    ;;
      *.ace)       unace x $1    ;;
      *)           echo "'$1' cannot be extracted via extract()"   ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

#buf - Back Up a file. Usage "bu filename.txt"
bu () {
  cp $1 ${1}-`date +%Y%m%d%H%M`.backup;
}

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting



# use DNS to query wikipedia (wiki QUERY)
wiki () { dig +short txt $1.wp.dg.cx; }

# mount an ISO file. (mountiso FILE)
mountiso () {
  name=`basename "$1" .iso`
  mkdir "/tmp/$name" 2>/dev/null
  sudo mount -o loop "$1" "/tmp/$name"
  echo "mounted iso on /tmp/$name"
}

#rename multiple files
rname () {
echo introduce from .extension
read iext
echo introduce to .extension
read text
for file in *$iext; do
    sudo mv "$file" "`basename $file $iext`$text"
done
}


# search inside pdf
searchpdf () {
  echo "introduce text to search"
  read text
  echo "introduce pdf filename"
  read pdf
  pdftotext $pdf - | grep '$text'
}

#wine in and out
  weneedwine () {
  read -p "file to wine" filewine
  wget http://dl.winehq.org/wine/source/1.8/wine-1.8.2.tar.bz2
  tar -jxvf wine**.bz2
  cd wine**
  sudo apt-get build-dep wine1.6
  ./configure --enable-win64
  make
  sudo make install
  sudo wine64 cmd $filewine
  sudo make uninstall
  sudo apt-get purge bison comerr-dev docbook docbook-dsssl docbook-to-man docbook-utils docbook-xsl execstack flex fontforge fontforge-common gir1.2-gst-plugins-base-0.10 gir1.2-gstreamer-0.10 jadetex krb5-multidev libasound2-dev libavahi-client-dev libavahi-common-dev libbison-dev libcapi20-3 libcapi20-dev libcups2-dev libdrm-amdgpu1 libdrm-dev libfl-dev libfontforge1 libgdraw4 libgl1-mesa-dev libglu1-mesa-dev libgphoto2-dev libgsm1-dev libgssrpc4 libgstreamer-plugins-base0.10-dev libgstreamer0.10-dev libieee1284-3-dev libkadm5clnt-mit9 libkadm5srv-mit9 libkdb5-7 libkrb5-dev libldap2-dev libmpg123-dev libodbc1 libopenal-dev libosmesa6 libosmesa6-dev libosp5 libostyle1c2 libptexenc1 libpulse-dev libsane-dev libsgmls-perl libsp1c2 libspiro0 libuninameslist0 libusb-1.0-0-dev libv4l-dev libv4l2rds0 libx11-xcb-dev libxcb-dri2-0-dev libxcb-dri3-dev libxcb-glx0-dev libxcb-present-dev libxcb-randr0 libxcb-randr0-dev libxcb-shape0-dev libxcb-sync-dev libxcb-xfixes0-dev libxshmfence-dev libxslt1-dev libxxf86vm-dev luatex lynx lynx-cur m4 mesa-common-dev ocl-icd-libopencl1 odbcinst odbcinst1debian2 opencl-headers openjade oss4-dev prelink sgml-data sgmlspl sp tex-common texlive-base texlive-binaries texlive-fonts-recommended texlive-generic-recommended texlive-latex-base texlive-latex-recommended tipa unixodbc unixodbc-dev valgrind x11proto-dri2-dev x11proto-gl-dev x11proto-xf86vidmode-dev
}

