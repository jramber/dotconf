# SET UP

This project use GNU Stow for the set up

If the repo has been cloned in a different folder than the home directory ('~'), do the following
´´´
    stow -t ~ nvim && stow -t ~ tmux
´´´

## Tmux configuration

Create the configuration file (`tmux.conf`) with `stow` at `~/.config/tmux/`, with the following command

´´´bash
    stow tmux 
´´´

Then, install Tmux Package Manager (TPM) following the repo instructions. To install it, you will need to do

´´´
    <prefix>I
´´´

