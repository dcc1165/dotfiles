# My personal dotfiles (Cross-platform MacOS/Unix and Linux)

This repo contains all dotfiles for a typical Linux o MacOS user.
The install script symlinks the dotfiles to their proper place under $HOME.
This makes it easy to keep dotfiles up-to-date with a simple 'git pull' in the
dotfiles repo directory.


All dot-files, OS agnostic (hopefully)
|ditfile|Description|
|-------|-----------|
|.bashrc              | Bash runtime configuration|
|.bash_profile        | Bash profile|
|.vimrc               | VIM runtime configuarion|
|.git-completion.sh   | Completion for Git repos|
|.git-prompt.sh       | Git-aware prompt|
|.gitconfig           | Global Git config|
|.gitflow_export      | Global Git Flow|
|.gitignore_global    | Global Git ignore|
|.ssh/config          | Standard ssh_config file|

Future - Split .bashrc into different files:
bash_functions       - User defined functions - maybe one file for each OS
                       or have one section for OS-related stuff.
bash_aliases         - User-defined aliases - same as above
bash_environment     - Bash environment variables
bash_colors          - Terminal text colorizations
