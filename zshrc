# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Fix the Java Problem
export _JAVA_AWT_WM_NONREPARENTING=1

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

PATH=/root/.local/bin:/snap/bin:/usr/sandbox/:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/share/games:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/bin/feroxbuster/

# Manual aliases
alias ll='lsd -lh --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias l='lsd --group-dirs=first'
alias lla='lsd -lha --group-dirs=first'
alias ls='lsd --group-dirs=first'
alias cat='bat'
alias nv='nvim'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Manual alisases (luk)
alias decbin="~/.config/bin/decbin"
alias ips="~/.config/bin/ips.sh"
alias btw="/usr/bin/neofetch"
alias luk="python3 ~/.config/bin/whoami.py"
alias catn="/usr/bin/cat"
alias bateria="/home/eltrompazo/.config/bin/batterystatus.sh"
# Plugins
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-sudo/sudo.plugin.zsh

# Functions
function mkt(){
	mkdir {nmap,content,exploits,scripts}
}

function settarget(){
	ip_adress=$1
	machine_name=$2
	echo "$ip_adress $machine_name" > /home/eltrompazo/.config/bin/target
}

function sysfetch(){
	~/.config/bin/sys-fetch
}

function cdback() {
  local num=$1
  if [[ -z $num ]]; then
    num=1
  fi
  while [[ $num -gt 0 ]]; do
    cd ..
    num=$((num-1))
  done
}

##############################################################################################################################################

# GTFOBINS en bash con function
function gtfobins(){

#!/bin/bash

# Parseamos los argumentos de la línea de comandos
while getopts ":f:" opt; do
  case $opt in
    f) file="$OPTARG"
    ;;
    \?) echo "Opción inválida: -$OPTARG" >&2
    exit 1
    ;;
  esac
done

# Comprobamos que el archivo especificado en el flag -f existe
if [ ! -f "$file" ]; then
    echo "Error: el archivo especificado no existe"
    echo "Ejecución correcta: bash script.sh -f /ruta/al/archivo"
    exit 1
fi

# Comprobamos que se ha especificado el flag -f
if [ -z "$file" ]; then
    echo "Error: no se ha especificado la ruta del archivo a analizar"
    echo "Ejecución correcta: bash script.sh -f /ruta/al/archivo"
    exit 1
fi

# Inicializamos un contador
counter=1

# Abrimos el archivo y leemos las líneas
while read -r line; do
  line=$(basename "$line" | tr -d '\r')
  r=$(curl -s "https://gtfobins.github.io/gtfobins/$line/")
  if [ "$?" -eq 0 ] && echo "$r" | grep -q "GTFOBins"; then
    # Imprimimos la numeración y el resultado
    printf "%s. %s es una vía potencial para escalar privilegios: https://gtfobins.github.io/gtfobins/%s/\n" "$counter" "${line^}" "$line"
    # Incrementamos el contador
    ((counter++))
  fi
done < "$file"
}

##############################################################################################################################################

# Extract nmap information
function extractPorts(){
	ports="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
	ip_address="$(cat $1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u | head -n 1)"
	echo -e "\n[*] Extracting information...\n" > extractPorts.tmp
	echo -e "\t[*] IP Address: $ip_address"  >> extractPorts.tmp
	echo -e "\t[*] Open ports: $ports\n"  >> extractPorts.tmp
	echo $ports | tr -d '\n' | xclip -sel clip
	echo -e "[*] Ports copied to clipboard\n"  >> extractPorts.tmp
	cat extractPorts.tmp; rm extractPorts.tmp
}

# Set 'man' colors
function man() {
    env \
    LESS_TERMCAP_mb=$'\e[01;31m' \
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    man "$@"
}

# fzf improvement
function fzf-lovely(){

	if [ "$1" = "h" ]; then
		fzf -m --reverse --preview-window down:20 --preview '[[ $(file --mime {}) =~ binary ]] &&
 	                echo {} is a binary file ||
	                 (bat --style=numbers --color=always {} ||
	                  highlight -O ansi -l {} ||
	                  coderay {} ||
	                  rougify {} ||
	                  cat {}) 2> /dev/null | head -500'

	else
	        fzf -m --preview '[[ $(file --mime {}) =~ binary ]] &&
	                         echo {} is a binary file ||
	                         (bat --style=numbers --color=always {} ||
	                          highlight -O ansi -l {} ||
	                          coderay {} ||
	                          rougify {} ||
	                          cat {}) 2> /dev/null | head -500'
	fi
}

function rmk(){
	scrub -p dod $1
	shred -zun 10 -v $1
}

bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ~/.powerlevel10k/powerlevel10k.zsh-theme
