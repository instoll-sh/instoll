#!/usr/bin/env bash

# shellcheck disable=SC2164

# Folder for the installation environment
# shellcheck disable=SC2153
TEMP="$PREFIX/tmp"
TEMP_DIR="$TEMP/instoller"
EXECUTABLE_LINK="https://github.com/instoll.sh/instoll/releases/latest/download/instoll"

mkdir "$TEMP_DIR"

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
    elif [[ -f '/etc/arch-release' || "$OSTYPE" =~ ^msys.*$ ]]; then
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


available() {
    command -v $1 >/dev/null
}

current_step=0
steps=3

if [[ ! "$SKIP_CHECKSUM_VALIDATION" == "true" ]]; then
    ((steps++))
fi


step() {
    ((current_step++))
    echo -e "\e[1;32m↪\e[0m [$current_step/$steps] \e[1m$1\e[0m"
}

# shasum_cmd=""
# if available sha256; then
#     shasum_cmd="sha256sum"
# elif available shasum; then
#     shasum_cmd="shasum -a 256"
# else
#     SKIP_CHECKSUM_VALIDATION="true"
#     write_log "Skipping checksum validation"
# fi

# validate_checksum() {
#     log $shasum_cmd --quiet --status -c $@
# }

cd "$TEMP_DIR"

echo ""

step "Downloading executable"
curl -fSLO --progress-bar "$EXECUTABLE_LINK"

SKIP_CHECKSUM_VALIDATION=true

if [[ ! $SKIP_CHECKSUM_VALIDATION == "true" ]]; then
    # ((steps++))
    step "Validating checksum"
    log curl -LOs "$EXECUTABLE_LINK.sha256"

    # File integrity check
    if validate_checksum instoll.sha256; then
        write_log "✅ Checksum validated"
    else
        write_log "❌ The checksum is invalid, please try again"
        write_log "    If the result is the same - report the error at this link: https://github.com/instoll.sh/instoll/issues/new?assignees=okineadev&labels=bug&template=bug_report.md&title=[Bug]:+invalid+checksum"

        log rm -rf "$TEMP_DIR"
        exit 1
    fi
fi

# Makes the script executable
chmod +x instoll


if [[ -f "$prefix/bin/instoll" ]]; then
    step "Updating"
else
    if [[ "$INSTOLL" == "true" ]]; then
        step "InstOlling"
    else
        step "Installing"
    fi
fi

if ! available git; then
    step "Installing dependencies"

    if [[ ! -n "$pkgmgr" ]]; then
        echo -e "$pkgmgr in not defined\nPlease install \e[1mjq\e[0m manually."
        exit 1
    else
        if [[ "$pkgmgr" == "brew" ]]; then
            if ! command -v brew >/dev/null; then
                # Command from https://brew.sh/#install
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
        fi

        # shellcheck disable=SC2086
        $sudo $pkgmgr $install jq
    fi
fi

$sudo cp instoll "$prefix/bin"

step "Cleaning"
rm -rf "$TEMP_DIR"

echo -e "\n\e[1;32mDone!\e[0m"
