# Yay
alias xclip='xclip -selection clipboard'

alias recent='uvx recent'

# Bash Function To Extract File Archives Of Various Types
extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1     ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1     ;;
             *.rar)       rar x $1       ;;
             *.gz)        gunzip $1      ;;
             *.tar)       tar xf $1      ;;
             *.tbz2)      tar xjf $1     ;;
             *.tgz)       tar xzf $1     ;;
             *.zip)       unzip $1       ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

alias kb=kubectl

alias install='sudo apt-get install'
alias remove='sudo apt-get remove'

export PATH="$PATH:/opt/nvim-linux64/bin"
export PATH="$HOME/.local/bin:$PATH"
export PATH=/home/ali/.opencode/bin:$PATH
alias opencode='opencode --agent plan'

alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# # Pulling dotfiles with git
# cd $HOME
# git clone --bare https://github.com/sefenub/dotfiles.git .dotfiles
# alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# config config --local status.showUntrackedFiles no
# config checkout
# # Checkout will fail unless conflicting files are deleted.

