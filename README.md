# prompt_colorizer

Copyright (c) 2011-2019 Aaron Myles Landwehr

## Info
  * This script can be used to stylize your console prompt. Currently there
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
-

### Clone:
```
cd ~
git clone git@github.com:snaphat/prompt_colorizer.git .prompt_colorizer
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
