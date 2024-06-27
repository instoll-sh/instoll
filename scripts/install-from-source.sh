#!/usr/bin/env bash

# Modifiable prefix variable
prefix="$PREFIX"
sudo="sudo"
pkgmgr=""
update="update"
install="install -y"

# If Linux OS or msys (linux emulator on Windows)
if echo "$OSTYPE" | grep -qE '^(linux-gnu|msys).*'; then
    if [ -f '/etc/debian_version' ]; then
        pkgmgr="apt"
    elif [[ -f '/etc/arch-release' || ( $(echo "$OSTYPE") =~ ^msys.*$ ) ]]; then
        pkgmgr="pacman"
        install="-Sy --noconfirm"
        update="-Sy"

        if echo "$OSTYPE" | grep -qE '^msys.*'; then
            # Because `sudo` in msys shell (on Windows™) are useless
            sudo=""
        fi
    fi

# macOS
elif echo "$OSTYPE" | grep -qE '^darwin.*'; then
    pkgmgr="brew"
    install="install"

    # The `/bin` directory in macOS is read-only, so you need to install the binary in `/usr/local`
    # https://github.com/openstreetmap/mod_tile/issues/349#issuecomment-1784165860
    prefix="/usr/local"

# Termux
elif echo "$OSTYPE" | grep -qE '^linux-android.*'; then
    pkgmgr="pkg"
    sudo=""
fi

current_step=0
steps=1


step() {
    ((current_step++))
    echo -e "\e[1;32m↪\e[0m [$current_step/$steps] \e[1m$1\e[0m"
}

echo ""

if [[ -f "$prefix/bin/instoll" ]]; then
    step "Updating"
else
    step "Installing"
fi

if ! command -v git >/dev/null; then
    ((steps++))
    step "Installing git"

    if [[ ! -n "$pkgmgr" ]]; then
        echo -e "$pkgmgr in not defined\nPlease install \e[1mjq\e[0m manually."
        exit 1
    else
        if [[ "$pkgmgr" == "brew" ]]; then
            if ! command -v brew >/dev/null; then
                # Code from https://brew.sh/#install
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
        fi

        $sudo $pkgmgr $install jq
    fi
fi

$sudo cp "instoll" "$prefix/bin"

echo -e "\n\e[1;32mDone!\e[0m"