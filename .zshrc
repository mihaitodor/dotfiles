# Install dependencies (manually)
# # Install iTerm2 from https://www.iterm2.com/
# # In iTerm2 go to Settings > Advanced and change `Scroll wheel sends arrow keys when in alternate screen mode` to Yes
# > brew install bash-completion coreutils gnu-tar gnu-sed the_silver_searcher fd ripgrep gnupg git go python3 pipx colima docker broot dust jless git-delta difftastic homeport/tap/dyff jesseduffield/lazydocker/lazydocker lazygit rustup glow
# > pipx install oshit
# > ssh-keygen -t rsa -b 4096
# > cat .ssh/id_rsa.pub # Paste the output in https://github.com/settings/keys -> SSH keys
# > gpg --default-new-key-algo rsa4096 --gen-key # Use output from `git config user.name` and `git config user.email`
# > gpg --list-keys --keyid-format SHORT
# > git config --global user.signingkey <pub_key_id>
# > git config --global commit.gpgsign true
# > gpg --armor --export <pub_key_id> # Paste the output in https://github.com/settings/keys -> GPG keys

# Command history
export HISTSIZE=10000000
export SAVEHIST=10000000
setopt extended_history       # Write the history file in the ":start:elapsed;command" format
setopt append_history         # Allow multiple parallel shells to append to the command history file
setopt inc_append_history     # Immediately append to the history file, not just when a term is killed
#setopt share_history          # Share history across terminals
setopt hist_expire_dups_first # Expire duplicate entries first when trimming history
setopt hist_expire_dups_first # Expire duplicate entries first when trimming history
setopt hist_find_no_dups      # Do not display a line previously found
setopt hist_reduce_blanks     # Remove superfluous blanks before recording entry

# Enhance zsh experience
setopt complete_aliases # Tab complete commands even behind aliases
setopt hist_verify      # Don't execute immediately upon history expansion when using `!...` to search for a previously-run command
export DIRSTACKSIZE=8   # Depth of directory stack
setopt auto_pushd       # Make the `cd` command push the previous dir onto dirstack
setopt pushd_silent     # Don't print the dirstack when running the `cd` command
setopt pushd_to_home    # Naked pushd (or cd with autopushd) takes you to the home dir

# Hide stupid OSX bash deprecation warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# Enable comments in interactive terminal
setopt interactive_comments

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

# pipx
export PATH=${HOME}/.local/bin:${PATH}

# Broot
source "${HOME}/.config/broot/launcher/bash/br"

# Docker (Colima)
export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"

# Kubernetes
alias k='kubectl'
