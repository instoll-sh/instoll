#!/usr/bin/env bash

# shellcheck disable=SC2164

# Folder for the installation environment
# shellcheck disable=SC2153
EXECUTABLE_LINK="https://github.com/instoll-sh/instoll/releases/latest/download/instoll"

INSTOLL_DIR="$PREFIX/usr/share/instoll"
ALIASES_PATH="$INSTOLL_DIR/aliases"
[[ -n "$ALIASES_REMOTE_REGISTRY" ]] || ALIASES_REMOTE_REGISTRY="https://raw.githubusercontent.com/instoll-sh/instoll-aliases/main/aliases"

# === COLORS ===
BOLD='\e[1m'
UNDERLINE='\e[4m'
RED='\e[31m'
BOLD_RED='\e[1;31m'
GREEN='\e[32m'
BOLD_GREEN='\e[1;32m'
RESET='\e[0m'

TEMP_DIR=$(mktemp -dt 'instoll-XXXXXX')

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
steps=4

if [[ ! "$SKIP_CHECKSUM_VALIDATION" == "true" ]]; then
    ((steps++))
fi


step() {
    ((current_step++))
    echo -e "${BOLD_GREEN}↪${RESET} [$current_step/$steps] ${BOLD}$1${RESET}"
}

shasum_cmd=""
if available sha256; then
    shasum_cmd="sha256sum"
elif available shasum; then
    shasum_cmd="shasum -a 256"
else
    SKIP_CHECKSUM_VALIDATION="true"
    echo "Skipping checksum validation"
fi

validate_checksum() {
    # shellcheck disable=SC2068
    $shasum_cmd --quiet --status -c $@
}

cd "$TEMP_DIR"

echo ""

step "Downloading executable"
curl -fSLO --progress-bar "$EXECUTABLE_LINK"

# SKIP_CHECKSUM_VALIDATION=true

if [[ ! "$SKIP_CHECKSUM_VALIDATION" == "true" ]]; then
    # ((steps++))
    step "Validating checksum"
    curl -LOs "$EXECUTABLE_LINK.sha256"

    # File integrity check
    if validate_checksum instoll.sha256; then
        echo "✅ Checksum validated"
    else
        echo "❌ The checksum is invalid, please try again"
        echo "    If the result is the same - report the error at this link: <${UNDERLINE}https://github.com/instoll-sh/instoll/issues/new?assignees=okineadev&labels=bug&template=bug_report.md&title=[Bug]:+invalid+checksum${RESET}>"

        rm -rf "$TEMP_DIR"
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
        echo -e "$pkgmgr in not defined\nPlease install ${BOLD}jq${RESET} manually."
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

step "Downloading a list of packages"
echo -e "  ${BOLD_GREEN}↪${RESET} ${BOLD}Registry${RESET}: $ALIASES_REMOTE_REGISTRY"

curl -fsO "$ALIASES_REMOTE_REGISTRY"

if [[ ! -d "$INSTOLL_DIR" ]]; then
    $sudo mkdir "$INSTOLL_DIR"
fi

$sudo cp "aliases" "$ALIASES_PATH"

step "Cleaning"
rm -rf "$TEMP_DIR"

echo -e "\n${BOLD_GREEN}Done!${RESET}"
