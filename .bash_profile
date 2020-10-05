# Install dependencies (manually)
# # Install iTerm2 from https://www.iterm2.com/
# # In iTerm2 go to Settings > Advanced and change `Scroll wheel sends arrow keys when in alternate screen mode` to Yes
# > brew install bash-completion the_silver_searcher gnupg git go python3 broot dust
# > ssh-keygen -t rsa -b 4096
# > cat .ssh/id_rsa.pub # Paste the output in https://github.com/settings/keys -> SSH keys
# > gpg --default-new-key-algo rsa4096 --gen-key # Use output from `git config user.name` and `git config user.email`
# > gpg --list-keys --keyid-format SHORT
# > git config --global user.signingkey <pub_key_id>
# > git config --global commit.gpgsign true
# > gpg --armor --export <pub_key_id> # Paste the output in https://github.com/settings/keys -> GPG keys

# Bash history size
export HISTSIZE=10000000

# Hide stupid OSX bash deprecation warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# brew
export PATH="/usr/local/sbin:${PATH}"

# Bash completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# Gpg
export GPG_TTY=$(tty)

# Git
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWCOLORHINTS=true
PROMPT_COMMAND='__git_ps1 "\u@\h:\W" "\$ "'
alias g='git'
__git_complete g _git

# The Silver Searcher
alias agcpp='ag -G "[ch]\+\+$"'

# Go
export GOPATH="${HOME}/Projects/go"
export PATH="${PATH}:${GOPATH}/bin"
export GO111MODULE=on

# Broot
source "${HOME}/.config/broot/launcher/bash/br"

# Minikube
export MINIKUBE_CPUS=4
export MINIKUBE_MEMORY=6144
alias minidocker='eval $(minikube docker-env)'
