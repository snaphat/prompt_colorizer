# prompt colorizer frontend script.
# Copyright (c) 2011-2016 Aaron Myles Landwehr
# Supports the following shells: bash, tcsh, zsh, ksh, and fish (including variants).
# A little hackery below to get this to work when sourced by different shells.

# You can change the colors for the prompt by looking in the backend.sh toward the bottom.
# The colors are simply stored in variables and used by the different prompts.
# The default style is 1.

# Run the backend script that does the real work (always uses bash)
# $argv holds the arguments for fish. There is no issue with tcsh here because $argv exist in tcsh.
bash ~/.prompt_colorizer/backend.sh "$HOME/.prompt_colorizer/temp.sh" "$1" "$0" $argv

# Backend script created a prompt variable based on which shell we are in.
# This will work with fish because we create a persistent 'source' function in the backend in that case.
source ~/.prompt_colorizer/temp.sh

# Cleanup
rm -f ~/.prompt_colorizer/temp.sh
