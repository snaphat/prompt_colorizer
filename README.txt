prompt colorizer script
Copyright (c) 2011-2014 Aaron Myles Landwehr

Info:
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

Installation:
  1.
      Move the prompt_colorizer directory into your home directory.

  2.
      Add the following line to your configuration file:
        source ~/prompt_colorizer/frontend.sh N

      * where N is 0, 1, 2, or 3 designating which style to use.

      * Configuration file names by shell:
              bash: .bashrc
              tcsh: .cshrc
              zsh:  .zshrc
              ksh:  .kshrc
              fish: .config/fish/config.fish

  3. (only for fish)
      * If you are using the fish shell, run the following command once:
          fish -c "function source; . \$argv; return; end; funcsave source;"
