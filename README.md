# Dotconf setup

This project use GNU Stow for the set up

If the repo has been cloned in a different folder than the home directory ('~'), do the following

```bash
    stow -t ~ nvim && stow -t ~ tmux
```

## Tmux configuration

Create the configuration file (`tmux.conf`) with `stow` at `~/.config/tmux/`, with the following command

```bash
    stow tmux 
```

Then, install Tmux Package Manager (TPM) following the repo instructions. To install it, you will need to do

```bash
    <prefix>I
```

## Nvim configuration

### NeoVim

If you want to install the `nightl` version of `nvim`, you can do so by pulling the repository on master and running the following commands:

```bash
    rm -r build/
    sudo make install
```

If you encounter any issues you can try the following

```bash
    make distclean
    make deps
```

> Remember to install `ripgrep` in order to be able to search with `telescope`

### LSP

In order for LSP and Mason to install all the server languages you will need to install `npm` first. To o so, run the following command:

```bash
    sudo apt install npm
```

> In order to run the LSP languages, remember that you need to install the LSP language server first.

## Kitty configuration

In order to set kitty as the default termnal you need to execute the following command and choose it as the main:

```bash
    sudo update-alternatives --config x-terminal-emulator
```

If kitty do not appear within the options, you will need to include it manually by doing the following:

```bash
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator <kitty installation path> 40
```

Alternative you can do:

```bash
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $(which kitty) 40
```

## Copilot

To use copilot you need to run the following command, and follow the instructions, inside nvim:

```bash
    :Copilot setup
```

## Biome

To format and lint files you can use `biome`. To install it, you can do the following:

```bash
    sudo npm install -g @biomejs/biome
```

Once you have it installed, you can install the LSP and formatter via Mason.

## ZSH

Zsh configuration requires `Zinit` package manager

## Set Zsh as the default shell

Run command:

```bash
chsh -s $(which zsh)
```

## Dependecies

* `npm`
* `ripgrep`
* `biome`
