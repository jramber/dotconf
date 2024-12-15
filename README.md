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

## Nvim configuration

In order for LSP and Mason to install all the server languages you will need to install `npm` first. To o so, run the following command:

´´´
    sudo apt install npm
´´´

## Kitty configuration

In order to set kitty as the default termnal you need to execute the following command and choose it as the main:

´´´
    sudo update-alternatives --config x-terminal-emulator
´´´

If kitty do not appear within the options, you will need to include it manually by doing the following:

´´´
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator <kitty installation path> 40
´´´

Alternative you can do:

´´´
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $(which kitty) 40
´´´
