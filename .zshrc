
if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
  exec dbus-run-session -- bash
  echo "D-Bus per-session daemon address is: $DBUS_SESSION_BUS_ADDRESS"
fi



# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:~/.local/bin:$PATH
export IDEA_JDK=/usr/lib/jvm/jre-jetbrains
export PHPSTORM_JDK=/usr/lib/jvm/jre-jetbrains
export WEBIDE_JDK=/usr/lib/jvm/jre-jetbrains
export WEBSTORM_JDK=/usr/lib/jvm/jre-jetbrains
export PYCHARM_JDK=/usr/lib/jvm/jre-jetbrains
export RUBYMINE_JDK=/usr/lib/jvm/jre-jetbrains
export CL_JDK=/usr/lib/jvm/jre-jetbrains
export DATAGRIP_JDK=/usr/lib/jvm/jre-jetbrains
export GOLAND_JDK=/usr/lib/jvm/jre-jetbrains
export STUDIO_JDK=/usr/lib/jvm/jre-jetbrains
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"
export FZF_DEFAULT_OPTS="--height 90% --layout=reverse --preview '(highlight -O ansi {} || cat {}) 2> /dev/null | head -500'"
export LANG="zh_CN.UTF-8"
export LANGUAGE="zh_CN.UTF-8"
export DEBUGINFOD_URLS="https://debuginfod.archlinux.org"
export G_SLICE=always-malloc
export MAVEN_HOME=/usr/local/maven
export PATH=$MAVEN_HOME/bin:$PATH
export OLLAMA_HOST=0.0.0.0
export INFERENCE_RAM=10
export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True


# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# 启动代理
proxy () {
  export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7891
  echo "HTTP Proxy on"
}

# 关闭代理
noproxy () {
  unset http_proxy
  unset https_proxy
  unset all_proxy
  echo "HTTP Proxy off"
}
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting vi-mode zsh-autosuggestions web-search zsh-completions fzf z)



ZSH_WEB_SEARCH_ENGINES=(
notion "https://www.notion.so/"
shimo "https://shimo.im"
asource "https://source.android.com/"
bilibili "https://www.bilibili.com/"
fengche "https://m.dm530p.in/"
acwing "https://www.acwing.com"
luogu "https://www.luogu.com.cn"
leetcode "https://leetcode.cn/"
atcode "https://atcoder.jp/"
markdown "https://markdown.com.cn/basic-syntax/"
csdn "https://blog.csdn.net/"
pta "https://pintia.cn/"

)

# z 是一款自动跳转的插件，对于你跳转后的目录，之后可以直接输入最终目录的名字，就可以正确跳转了
# vi-mode就可以将vim党从这种尴尬的处境中解脱出来，安装好插件后，默认是输入模式，你可以正常输入，当需要跳转时，按下Esc轻松切换至命令模式，然后你就可以随意跳转了。
## 1、ngg/nG （跳转到文件第n行，无需回车）

## 2、:n （跳转到文件第n行，需要回车）

## 3、vim +n filename （在打开文件后，跳转到文件的第n行）

source $ZSH/oh-my-zsh.sh
source ~/motd.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias pac='yay -S $(yayfzf)'
alias ins='bash ~/install_yay.sh'
alias cls='clear'
alias run='./run.sh'
alias ai='aichat'
alias n='neofetch'
# alias ra='yazi'
alias load='tmux at -t'
alias q='exit'
alias lazy='lazygit'
alias tree='lsd --tree'
alias homew='curl https://wttr.in/Zhangzhou'
alias schoolw='curl https://wttr.in/Ningbo'
alias ze='zellij'
alias ls='lsd'
alias ping='gping'
alias e='exa --icons'
alias tt='tldr'
alias nv='nvim'
alias vim='nvim'
alias t='fanyi'
alias scr='scrcpy --max-size 1920 --max-fps 120'
alias e='nvim $(fzf)'
alias cf='$(find * -type d | fzf)'
alias ps='kitty +kitten icat' 
alias mem='./checkmemory.sh'
alias cat='bat'
alias nvsql="nvim '+SQLua'"
eval "$(oh-my-posh init zsh --config ~/clean-detailed.omp.json)"



function ra() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# export PYTHONPATH=$PYTHONPATH:/usr/lib/python/site-packages
# export PYTHONPATH=$PYTHONPATH:/usr/lib/python3.12
# export PATH="/usr/local/bin/:$PATH"
# export PATH="/usr/bin/:$PATH"
# export PATH=" $HOME/.cargo/bin/:$PATH"
# export C_INCLUDE_PATH=/usr/local/include:$C_INCLUDE_PATH
# export CPLUS_INCLUDE_PATH=/usr/local/include:$CPLUS_INCLUDE_PATH


. "$HOME/.cargo/env"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/encounter/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/encounter/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/encounter/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/encounter/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

