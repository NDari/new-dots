Set-PSReadLineOption -EditMode Emacs

Set-PSReadLineOption -BellStyle None

Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# aliases
Set-Alias -Name e -Value nvim
Set-Alias -Name which -Value Get-Command
