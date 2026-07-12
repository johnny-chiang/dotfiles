#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# dotfiles installer
# Usage:
#   ./install.sh              # Full install
#   ./install.sh --uninstall  # Remove all stow symlinks
#   ./install.sh --stow-only  # Stow only (skip Homebrew)
# ============================================================

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Stow packages (excluding homebrew and raycast)
STOW_PACKAGES=(ghostty nvim starship vim zsh)

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[✓]${NC} $*"; }
warn()    { echo -e "${YELLOW}[!]${NC} $*"; }
error()   { echo -e "${RED}[✗]${NC} $*"; exit 1; }
step()    { echo -e "\n${BOLD}${BLUE}==>${NC}${BOLD} $*${NC}"; }

# --- Uninstall ---
uninstall() {
    step "Removing all stow symlinks"
    for pkg in "${STOW_PACKAGES[@]}"; do
        if stow -n -D -d "$DOTFILES_DIR" -t "$HOME" "$pkg" 2>/dev/null; then
            stow -D -d "$DOTFILES_DIR" -t "$HOME" "$pkg"
            success "Removed: $pkg"
        else
            warn "Skipped: $pkg (not linked or doesn't exist)"
        fi
    done
    success "Uninstall complete!"
    exit 0
}

# --- Homebrew ---
install_homebrew() {
    step "Checking Homebrew"
    if command -v brew &>/dev/null; then
        success "Homebrew is already installed"
        info "Running brew update..."
        brew update
    else
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Load Homebrew (ARM Mac)
        if [[ -f /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        success "Homebrew installed successfully"
    fi
}

# --- Brew Bundle ---
install_packages() {
    step "Installing packages (brew bundle)"
    if [[ -f "$DOTFILES_DIR/homebrew/Brewfile" ]]; then
        brew bundle install --file="$DOTFILES_DIR/homebrew/Brewfile" --no-lock
        success "All packages installed"
    else
        error "Brewfile not found: $DOTFILES_DIR/homebrew/Brewfile"
    fi
}

# --- Backup ---
backup_existing() {
    step "Backing up existing configs"
    local needs_backup=false

    for pkg in "${STOW_PACKAGES[@]}"; do
        # Find target files that stow would create
        while IFS= read -r -d '' file; do
            local rel="${file#"$DOTFILES_DIR/$pkg/"}"
            local target="$HOME/$rel"
            # If target exists, check if it already points to the dotfiles repo (already stowed)
            if [[ -e "$target" ]]; then
                local real_target
                real_target="$(realpath "$target" 2>/dev/null || true)"
                # Skip files already pointing to repo (symlink or tree-folding)
                if [[ "$real_target" == "$DOTFILES_DIR"/* ]]; then
                    continue
                fi
                needs_backup=true
                local backup_path="$BACKUP_DIR/$rel"
                mkdir -p "$(dirname "$backup_path")"
                mv "$target" "$backup_path"
                warn "Backed up: $target → $backup_path"
            fi
        done < <(find "$DOTFILES_DIR/$pkg" -type f -not -name '.DS_Store' -print0)
    done

    if [[ "$needs_backup" == true ]]; then
        success "Backup complete → $BACKUP_DIR"
    else
        info "No backup needed (no conflicting files found)"
    fi
}

# --- Stow ---
stow_packages() {
    step "Creating symlinks (GNU Stow)"

    if ! command -v stow &>/dev/null; then
        error "GNU Stow is not installed. Run: brew install stow"
    fi

    for pkg in "${STOW_PACKAGES[@]}"; do
        stow -d "$DOTFILES_DIR" -t "$HOME" --restow "$pkg"
        success "Linked: $pkg"
    done

    success "All configs linked successfully"
}

# --- Post-install ---
post_install() {
    step "Post-install setup"

    # Ensure XDG directories exist
    mkdir -p "$HOME/.config" "$HOME/.cache" "$HOME/.local/share" "$HOME/.local/state"
    info "XDG directories ready"

    # Next steps
    echo ""
    info "🎉 Installation complete! Here are some next steps:"
    echo ""
    echo "  1. Restart your terminal, or run: exec zsh"
    echo "  2. Raycast settings need to be imported manually:"
    echo "     → Open Raycast → Settings → Advanced → Import"
    echo "     → File: $DOTFILES_DIR/raycast/raycast.rayconfig"
    echo "  3. Neovim will auto-install plugins (LazyVim) on first launch"
    echo ""
}

# --- Main ---
main() {
    echo -e "${BOLD}"
    echo "  ╔══════════════════════════════════════╗"
    echo "  ║       🏠 Dotfiles Installer          ║"
    echo "  ╚══════════════════════════════════════╝"
    echo -e "${NC}"

    case "${1:-}" in
        --uninstall)
            uninstall
            ;;
        --stow-only)
            backup_existing
            stow_packages
            post_install
            ;;
        *)
            install_homebrew
            install_packages
            backup_existing
            stow_packages
            post_install
            ;;
    esac
}

main "$@"
