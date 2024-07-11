# Install dependencies (manually)
# # Install iTerm2 from https://www.iterm2.com/
# # In iTerm2 go to Settings > Advanced and change `Scroll wheel sends arrow keys when in alternate screen mode` to Yes
# > brew install bash-completion coreutils gnu-tar gnu-sed the_silver_searcher fd bat ripgrep jq gnupg git go python3 pipx colima docker docker-compose broot mc dua-cli dust jless git-delta difftastic homeport/tap/dyff jesseduffield/lazydocker/lazydocker lazygit rustup npm glow libpq pgcli kubectl helm dive mitmproxy maccy
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
setopt complete_aliases     # Tab complete commands even behind aliases
setopt hist_verify          # Don't execute immediately upon history expansion when using `!...` to search for a previously-run command
export DIRSTACKSIZE=8       # Depth of directory stack
setopt auto_pushd           # Make the `cd` command push the previous dir onto dirstack
setopt pushd_silent         # Don't print the dirstack when running the `cd` command
setopt pushd_to_home        # Naked pushd (or cd with autopushd) takes you to the home dir
setopt interactive_comments # Enable comments in interactive terminal

# Hide OSX bash deprecation warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# Enable autocompletion
autoload -Uz compinit && compinit

# Gpg
export GPG_TTY=$(tty)

# Git
function parse_git_branch() {
  # Try to fetch the current branch, if any
  ref=$(git rev-parse --abbrev-ref HEAD 2> /dev/null) || true
  if [[ "${ref}" == "HEAD" ]]; then
    # If we're not on a branch, then try to fetch the current (latest) tag which matches the current commit
    # If we can't find any tag for this commit, then return the current short SHA
    ref=$(git describe --exact-match --tags 2> /dev/null || git rev-parse --short --verify HEAD 2> /dev/null) || true
  fi

  if [[ -z "${ref}" ]]; then
    # Check if we're in a git repo which might be freshly-initialised and not contain any commits
    if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]]; then
      echo " [#] "
    else
      echo " "
    fi
    # Bail out early if we couldn't find any ref
    exit
  fi

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
alias gd='git -c core.pager=delta -c delta.navigate=true'
alias gdd='git -c core.pager=delta -c delta.side-by-side=true -c delta.navigate=true'
# Fix trackpad scroll when using delta for diffs
export DELTA_PAGER='less --mouse'

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

# Benthos
alias benthos=redpanda-connect
