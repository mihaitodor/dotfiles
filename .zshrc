# Install dependencies (manually)
# # Install iTerm2 from https://www.iterm2.com/
# # In iTerm2 go to Settings > Advanced and change `Scroll wheel sends arrow keys when in alternate screen mode` to Yes
# > brew install bash-completion coreutils gnu-tar gnu-sed the_silver_searcher fd ripgrep gnupg git go python3 pipx broot dust jless difftastic homeport/tap/dyff jesseduffield/lazydocker/lazydocker lazygit rustup glow
# > pipx install oshit
# > ssh-keygen -t rsa -b 4096
# > cat .ssh/id_rsa.pub # Paste the output in https://github.com/settings/keys -> SSH keys
# > gpg --default-new-key-algo rsa4096 --gen-key # Use output from `git config user.name` and `git config user.email`
# > gpg --list-keys --keyid-format SHORT
# > git config --global user.signingkey <pub_key_id>
# > git config --global commit.gpgsign true
# > gpg --armor --export <pub_key_id> # Paste the output in https://github.com/settings/keys -> GPG keys

# Command history size
export HISTSIZE=10000000

# Hide stupid OSX bash deprecation warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# Enable autocompletion
autoload -Uz compinit && compinit

# Gpg
export GPG_TTY=$(tty)

# Git
function parse_git_branch() {
  ref=$(git rev-parse --abbrev-ref HEAD 2> /dev/null) || { echo " "; return }
  if [[ -n $(git status -s -uno --ignore-submodules=dirty 2> /dev/null) ]]; then
    echo " [${ref} *] "
  else
    echo " [${ref}] "
  fi
}
COLOR_DEF=$'%f'
COLOR_USR=$'%F{243}'
COLOR_DIR=$'%F{197}'
COLOR_GIT=$'%F{39}'
setopt PROMPT_SUBST
export PROMPT='${COLOR_USR}%n@%m ${COLOR_DIR}%~${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}%% '
alias g='git'

# The Silver Searcher
alias agcpp='ag -G "[ch]\+\+$"'
alias agg='ag --go'
alias agp='ag --py'

# Go
export PATH="${PATH}:$(go env GOPATH)/bin"
function goimports_all() {
  # Usage: goimports_all excluded_dir1 excluded_dir2 ...

  declare -a excluded_folders
  for folder in "$@"; do
    excluded_folders+=(-not -path "./${folder}/*")
  done

  find . -name \*.go "${excluded_folders[@]}" -exec goimports -w {} \;
}

# Broot
source "${HOME}/.config/broot/launcher/bash/br"

# Kubernetes
alias k='kubectl'
