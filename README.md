# prompt_colorizer

Copyright (c) 2011-2019 Aaron Myles Landwehr

## About
Prompt Colorizer is a set of small scripts that implement four different styles of colored prompts for a number of different shells. Each style displays session information including: username, hostname, current directory (short and long), date, time, and git repository information (the latter is for bash/zsh/fish only and only with git-core installed). Click on the image to the right to see samples of the four styles. The idea of this set of scripts is to have an easy to set up and decent prompt without putting in a lot of effort to configure it on multiple systems with differing default shells.

![Prompt Colorizer Example Image](https://raw.githubusercontent.com/snaphat/prompt_colorizer/assets/prompt-colorizer-examples.png)

## Details
  * These scripst can be used to stylize your console prompt. Currently there
    are 4 different styles to choose from.

  * It is designed in such a way that it works with a many different shell
    interpreters. The currently tested list is as follows:
    * bash
    * tcsh
    * zsh
    * ksh, pdksh, mksh
    * fish

  * Some shell interpreters will show the current git branch in the prompt
    These are as follows:
    * bash
    * zsh
    * fish

## Installation

### Clone:
```
cd ~
git clone git@github.com:snaphat/prompt_colorizer.git .prompt_colorizer
or
git clone https://github.com/snaphat/prompt_colorizer.git .prompt_colorizer
```

### Add the following line to your configuration file where N is 0, 1, 2, or 3 designating which style to use:
```
source ~/.prompt_colorizer/frontend.sh N
```
#### Configuration file names by shell:

| Shell | Config Location          |
| ----- | ------------------------ |
| bash  | .bashrc                  |
| tcsh  | .cshrc                   |
| zsh   | .zshrc                   |
| ksh   | .kshrc                   |
| fish  | .config/fish/config.fish |


### Only for fish shell, run the following command once:
```
fish -c "function source; . \$argv; return; end; funcsave source;"
```
