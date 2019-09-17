# prompt colorizer backend script.
# Copyright (c) 2011-2016 Aaron Myles Landwehr
# Supports the following shells: bash, tcsh, zsh, ksh, and fish (including variants).

#Default style
DEFAULT_STYLE=1

TEMP_FILE=$1                          #Grab temp file to source in caller shell.
PLATFORM=`uname`
CHOSEN_STYLE=$2                       #Chosen style.
CALLER_SHELL=${3##-}                  #Grab caller shell arg0; remove '-' if prefixed.
CALLER_SHELL=${CALLER_SHELL##*/}      #Grab the basename in case of a path being attached to the shell name. E.g. /bin/bash.
if [[ ${PLATFORM} == "windows32" ]]; then #emulate 'ps' command in windows. Needs GOW or equivalent.
    CALLER_SHELL_PS=`tasklist -fi "PID eq $PPID" | grep $PPID | tr -s ' ' | cut -d '.' -f1`
else
    CALLER_SHELL_PS=`ps -ocomm= -p $PPID` #Grab the parent process shell.
    CALLER_SHELL_PS=${CALLER_SHELL_PS##-} #Remove '-' if prefixed.
fi

#Detect whether the frontend was called in bash or tcsh (note: backend is always called using bash)
if [[ ${CALLER_SHELL_PS} == *bash* ]]; then
    #bash
    STRPFX="\$'"; STRSFX="'"                #Prefix & suffix of prompt string.
    BEGCMD="\["; ENDCMD="\]"                #Color command beginning and end.
    LINBRK="\\n"                            #Line break.
    SETCMD="PS1="                           #Prompt variable to set.
    USER="\\u"                              #Username.
    HOST='\\H'                              #Hostname.
    PTH="\\w"                               #Full path the current working directory.
    CWD="\\W"                               #Based name of the current working directory.
    DATE="\\d"                              #Date.
    TIME="\@"                               #Time.

    #git show branch in prompt for bash.
    GIT='`__git_ps1`'
    PREFIX_TEXT="source ~/.prompt_colorizer/git-prompt.sh"
elif [[ ${CALLER_SHELL_PS} == *zsh* ]]; then
    #zsh
    STRPFX="\$'"; STRSFX="'"                #Prefix & suffix of prompt string.
    BEGCMD="%{"; ENDCMD="%}"                #Color command beginning and end.
    LINBRK="\\n"                            #Line break.
    SETCMD="PROMPT="                        #Prompt variable to set.
    USER="%n"                               #Username.
    HOST="%M"                               #Hostname.
    PTH="%~"                                #Full path the current working directory.
    CWD="%1/"                               #Based name of the current working directory.
    DATE="%D{%a %b %d}"                     #Date.
    TIME="%D{%r}"                           #Time.

    #git show branch in prompt for zsh.
    GIT='`__git_ps1`'
    PREFIX_TEXT='source ~/.prompt_colorizer/git-prompt.sh; prompt off; setopt prompt_subst'

    #zsh fixes.
    CALLER_SHELL=${CALLER_SHELL_PS} #caller shell is always the scriptname for zsh.
elif [[ ${CALLER_SHELL_PS} == *tcsh* ]]; then
    #tcsh
    STRPFX="\""; STRSFX="\""                #Prefix & suffix of prompt string.
    BEGCMD="%{"; ENDCMD="%}"                #Color command beginning and end.
    LINBRK="\\n"                            #Line break.
    SETCMD="set prompt="                    #Prompt variable to set.
    USER="%n"                               #Username.
    HOST="%M"                               #Hostname.
    PTH="%~"                                #Full path the current working directory.
    CWD="%c"                                #Based name of the current working directory.
    DATE="%d %w %D"                         #Date.
    TIME="%p"                               #Time.
elif [[ ${CALLER_SHELL_PS} == *ksh* ]]; then
    #ksh, pdksh, mksh
    STRPFX="\$'"; STRSFX="'"                #Prefix & suffix of prompt string.
    BEGCMD=""; ENDCMD=""                    #Color command beginning and end.
    LINBRK="\\n"                            #Line break.
    SETCMD="PS1="                           #Prompt variable to set.
    USER="\$(echo `logname`)"               #Username.
    HOST="\$(echo `hostname`)"              #Hostname.
    PTH="\$(pwd)"                           #Full path the current working directory.
    CWD="\$(basename \$(pwd))"              #Based name of the current working directory.
    DATE="\$(date \"+%a %b %d\")"           #Date.
    TIME="\$(date \"+%r\")"                 #Time.
elif [[ ${CALLER_SHELL_PS} == *fish* ]]; then
    #fish
    STRPFX="\""; STRSFX="\""                #Prefix & suffix of prompt string.
    BEGCMD="'"; ENDCMD="'"                  #Color command beginning and end.
    LINBRK="'\\n'"                          #Line break.
    SETCMD="set -g PS1 "                    #Prompt variable to set.
    USER="(whoami)"                         #Username.
    HOST="(hostname)"                       #Hostname.
    PTH="(pwd)"                             #Full path the current working directory.
    CWD="(basename (pwd))"                  #Based name of the current working directory.
    DATE="(date '+%a %b %d')"               #Date.
    TIME="(date '+%r')"                     #Time.

    #fish uses a function to print the prompt so it is more work for us.
    PREFIX_TEXT=$'function fish_prompt;'
    PREFIX_TEXT=${PREFIX_TEXT}$'set PS2 "echo $PS1";' #Setup path var to be echo'd on eval without expanding escape characters.
    PREFIX_TEXT=${PREFIX_TEXT}$'set PS3 (eval $PS2);' #Expand prompt.
    PREFIX_TEXT=${PREFIX_TEXT}$'echo -e "$PS3";'      #Print prompt.
    PREFIX_TEXT=${PREFIX_TEXT}$'end;'

    #git show branch in prompt for fish.
    GIT=' (__git_ps1)'
    PREFIX_TEXT=${PREFIX_TEXT}$'function __git_ps1;'
    PREFIX_TEXT=${PREFIX_TEXT}$'if which git > /dev/null; if git rev-parse --git-dir > /dev/null 2>&1; printf "(%s)" (basename (git symbolic-ref HEAD 2> /dev/null; or echo (git rev-parse --short HEAD 2> /dev/null; printf "\x08..."))); end; end;'
    PREFIX_TEXT=${PREFIX_TEXT}$'end;'

    #fish fixes.
    CHOSEN_STYLE=$4 #Fish uses a special $argv variable which we passed as bash arg $4 and beyond.
    CALLER_SHELL=${CALLER_SHELL_PS} #caller shell doesn't exist for fish and a script can only be sourced anyway.
else
    #unknown
    NOT_FOUND=1
fi

#Foreground, Background, NULL, DULL, BRIGHT
FG_BLACK=30; FG_RED=31; FG_GREEN=32; FG_YELLOW=33; FG_BLUE=34; FG_VIOLET=35; FG_CYAN=36; FG_WHITE=37
BG_BLACK=40; BG_RED=41; BG_GREEN=42; BG_YELLOW=43; BG_BLUE=44; BG_VIOLET=45; BG_CYAN=46; BG_WHITE=47
NULL=00; DULL=0; BRIGHT=1

# ANSI Escape Commands
ESC="\033"
NORMAL="${BEGCMD}${ESC}[m${ENDCMD}"

# Unencapsulated foreground text variables.
UBLK="${ESC}[${BRIGHT};${FG_BLACK}m"
URED="${ESC}[${BRIGHT};${FG_RED}m"
UGRN="${ESC}[${BRIGHT};${FG_GREEN}m"
UYLW="${ESC}[${BRIGHT};${FG_YELLOW}m"
UBLU="${ESC}[${BRIGHT};${FG_BLUE}m"
UVLT="${ESC}[${BRIGHT};${FG_VIOLET}m"
UCYN="${ESC}[${BRIGHT};${FG_CYAN}m"
UWHT="${ESC}[${BRIGHT};${FG_WHITE}m"
URESET="${ESC}[${DULL};${FG_WHITE};${NULL}m"

# Bright foreground text variables.
BBlK="${BEGCMD}${UBLK}${ENDCMD}"
BRED="${BEGCMD}${URED}${ENDCMD}"
BGRN="${BEGCMD}${UGRN}${ENDCMD}"
BYLW="${BEGCMD}${UYLW}${ENDCMD}"
BBLU="${BEGCMD}${UBLU}${ENDCMD}"
BVLT="${BEGCMD}${UVLT}${ENDCMD}"
BCYN="${BEGCMD}${UCYN}${ENDCMD}"
BWHT="${BEGCMD}${UWHT}${ENDCMD}"
RESET="${BEGCMD}${URESET}${ENDCMD}"

#Supported Styles.
STYLE_0="${STRPFX}${BWHT}\133${BGRN}${USER}${BBLU}@${BYLW}${HOST}${BWHT}\135 ${BRED}\133${PTH}\135 ${BVLT}\133${DATE}\135 ${BCYN}\133${TIME}\135${BWHT}${GIT} ${LINBRK}${BRED}\076${RESET}\040${STRSFX}"
STYLE_1="${STRPFX}${BVLT}\133${BGRN}${DATE} ${BVLT}- ${BGRN}${TIME}${BVLT}\135 ${BBLU}\133${BYLW}${PTH}${BBLU}\135${BWHT}${GIT} ${LINBRK}${BRED}\133${BCYN}${USER}${BRED}@${BCYN}${HOST}${BRED}\135 ${BWHT}\044${RESET}\040${STRSFX}"
STYLE_2="${STRPFX}${BWHT}${BGRN}${USER}${BBLU}@${BYLW}${HOST}${BWHT}:${BRED}${CWD}${BCYN}${GIT}${BWHT}\044${RESET}\040${STRSFX}"
STYLE_3="${STRPFX}${BVLT}\133${BGRN}${TIME}${BVLT} - ${BGRN}${DATE}${BVLT}\135 ${BRED}\133${BCYN}${USER}${BRED}@${BCYN}${HOST}${BRED}\135 ${BBLU}\133${BYLW}${PTH}${BBLU}\135${BWHT}${GIT} ${LINBRK}${BWHT}\076${RESET}\040${STRSFX}"

if [[ $NOT_FOUND == 1 ]]; then
    printf "${BRED}Prompt Colorizer Warning${RESET}: Unknown shell (${CALLER_SHELL_PS}), cannot colorize prompt...\n"
    kill $PPID; #Fail.
elif [[ ${CALLER_SHELL} != ${CALLER_SHELL_PS} ]]; then #Caller shell should match the process if sourced.
    printf "Usage: ${UYLW}source${UCYN} ~/.prompt_colorizer/frontend.sh ${UGRN}NUM${URESET}\n"
    printf "       Where ${UGRN}NUM${URESET} indicates the prompt style.\n"
    printf "       Only ${UVLT}0${URESET}, ${UVLT}1${URESET}, and ${UVLT}2${URESET} are supported.\n"
    echo -E "" > ${TEMP_FILE}
    exit 1; #Fail.
else
    #Grab chosen style id.
    if [[ -z "$CHOSEN_STYLE" ]]; then
        printf "${URED}Prompt Colorizer Warning${URESET}: No style chosen, selecting default...\n"
        STYLE_NUMBER=${DEFAULT_STYLE} #default.
    else
        STYLE_NUMBER=${CHOSEN_STYLE}
    fi

    #Create chosen style variable.
    CHOSEN_STYLE="STYLE_${STYLE_NUMBER}"

    if [[ -z "${!CHOSEN_STYLE}" ]]; then
        printf "${URED}Prompt Colorizer Warning${URESET}: Chosen prompt style not found, selecting default...\n"
        CHOSEN_STYLE="STYLE_${DEFAULT_STYLE}"
    fi

    #Prefix text to add to file.
    echo -E "${PREFIX_TEXT}" > ${TEMP_FILE}

    #Write out prompt to temp file - it will be sourced in the parent shell.
    echo -E ${SETCMD}${!CHOSEN_STYLE} >> ${TEMP_FILE}
    exit 0; #Success.
fi
