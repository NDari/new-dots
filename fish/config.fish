# source /usr/share/cachyos-fish-config/cachyos-config.fish

# variables
set -U DOTS {$HOME}/dotfiles

set -U XDG_CONFIG_HOME $HOME/.config
set -U XDG_DATA_HOME $HOME/.local/share
set -U XDG_CACHE_HOME $HOME/.cache
set -U XDG_STATE_HOME $HOME/.local/state

set -U EDITOR "nvim"
set -gx EDITOR "nvim"
set -U VISUAL "nvim"

set -U GOPATH $HOME/go
set -U GOBIN $GOPATH/bin # has to be abs or use $GOPATH
set -U GOMODCACHE $GOPATH/pkg/mod
set -U GOCACHE $XDG_CACHE_HOME/go-build

# aliases
if test (uname) = "Darwin"
    # macOS — pbcopy and pbpaste are already available natively, nothing to do
else if test (uname) = "Linux"
    if set -q WAYLAND_DISPLAY
        alias pbcopy  "wl-copy"
        alias pbpaste "wl-paste -n"
    else if set -q DISPLAY
        alias pbcopy  "xclip -selection clipboard -in"
        alias pbpaste "xclip -selection clipboard -out"
    end
end

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
abbr --add we '$EDITOR $WEZTERM_CONFIG_DIR/wezterm.lua'
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

