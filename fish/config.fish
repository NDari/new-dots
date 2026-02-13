# source /usr/share/cachyos-fish-config/cachyos-config.fish

# variables
set -U DOTS {$HOME}/dotfiles
#
# set -gx XDG_CONFIG_HOME $HOME/.config
# set -gx XDG_DATA_HOME $HOME/.local/share
# set -gx XDG_CACHE_HOME $HOME/.cache
# set -gx XDG_STATE_HOME $HOME/.local/state
# set -gx
# set -gx EDITOR "nvim"
# set -gx VISUAL "nvim"
# set -gx
# set -gx GOPATH $HOME/go
# set -gx GOBIN $GOPATH/bin # has to be abs or use $GOPATH
# set -gx GOMODCACHE $GOPATH/pkg/mod
# set -gx GOCACHE $XDG_CACHE_HOME/go-build

# paths

fish_add_path -U {$HOME}/.cargo/bin
fish_add_path -U {$HOME}/go/bin

# abbrs
abbr --add e 'nvim'
abbr --add vi 'NVIM_APPNAME="minvim" nvim'
abbr --add mvi 'NVIM_APPNAME="nvim-minimax" nvim'
abbr --add vdiff "nvim -d"
abbr --add less 'less -R' # pass escape chars through
abbr --add c 'clear'
abbr --add enw 'emacs -nw'
abbr --add ls 'ls --color=always'
abbr --add h 'history | fzf'
abbr --add we 'e $WEZTERM_CONFIG_DIR/wezterm.lua'
# --add git
abbr --add ga 'git add'
abbr --add gd 'git diff'
abbr --add gst 'git status'
abbr --add gp 'git push'
abbr --add gc 'git commit'
abbr --add gpo 'gp --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'
# tmux
abbr --add tns 'tmux new-session -s'
abbr --add tl 'tmux list-sessions'
abbr --add ta 'tmux attach -t'
# copy and paste commands
#abbr --add pbcopy 'xclip -selection clipboard'
#abbr --add pbpaste 'xclip -selection clipboard -o'
# fix watch
abbr --add watch "watch "
# pacman
abbr --add search "pacman -Slq | fzf --preview 'pacman -Si {}' --layout=reverse --height 50%"

# start things if they exist
# if type -q starship
#     starship init fish | source
# end

if type -q oh-my-posh
    oh-my-posh init fish --config {$DOTS}/oh-my-posh/term-theme.toml | source
end

