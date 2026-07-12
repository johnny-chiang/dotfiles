# dotfiles

macOS development environment dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Included Configs

| Package | Description |
|---|---|
| `ghostty` | Ghostty terminal config (Catppuccin Mocha theme) |
| `homebrew` | Brewfile (all formulae and casks) |
| `nvim` | Neovim config (LazyVim framework) |
| `raycast` | Raycast settings export (manual import required) |
| `starship` | Starship prompt theme |
| `vim` | Vim config + Catppuccin colorscheme |
| `zsh` | Zsh shell config |

## Quick Install

```bash
git clone https://github.com/johnny-chiang/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

### Other Options

```bash
# Stow only (skip Homebrew)
./install.sh --stow-only

# Remove all symlinks
./install.sh --uninstall
```

## Backup

The install script automatically backs up existing configs to `~/.dotfiles_backup/` before overwriting.