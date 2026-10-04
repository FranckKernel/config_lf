If you already have the zsh and tmux done, it should be rather quick
But you still need to install one thing

install commands:

```bash
# Backup existing ~/.config/lf if it exists, using numbered backups (~1, ~2, etc.)
[ -d ~/.config/lf ] && mv --backup=numbered ~/.config/lf ~/.config/lf_backup

# Clone the lf configuration repository
git clone https://github.com/PoutineSyropErable/config_lf ~/.config/lf
```

System package install:

On Arch:

```
yay -S ctpv
```

On MacOS

```
brew install ctpv
```
