# Created by newuser for 5.9

# set the directory we want to sthore zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zshconfig.toml)"

# Disable auto titles
DISABLE_AUTO_TITLE=true

export PATH=$HOME/Dev/pullsys/:$PATH

# pull system alias
alias pullsys="$HOME/Dev/pullsys/pullsys"

# mvn setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion # We use zsh ma boy

export PATH=$HOME/Downloads/lua-language-server/bin:$PATH
