#!/bin/bash

clear

echo "                 "$'\e[0;31m'---
echo "  "___======____=$'\e[0;33m'-$'\e[1;33m'-$'\e[0;33m'-=$'\e[0;31m'")"
echo /T"            \\"_$'\e[1;33m'--=$'\e[0;33m'==$'\e[0;31m'")"
echo [" \\ "$'\e[0;33m'"("$'\e[1;33m'0$'\e[0;33m'")   "$'\e[0;31m'"\\~     \\_"$'\e[1;33m'-=$'\e[0;33m'=$'\e[0;31m'")"
echo " \\      / )J"$'\e[0;33m'~~"     "$'\e[0;31m'"\\"$'\e[1;33m'-=$'\e[0;31m'")"
echo "  \\\\___/  )JJ"$'\e[0;33m'~$'\e[1;33m'~~"   "$'\e[0;31m'"\\)"
echo "   \\_____/JJJ"$'\e[0;33m'~~$'\e[1;33m'~~"    "$'\e[0;31m'"\\"
echo "   "$'\e[0;33m'/$'\e[0;31m'" \\  "$'\e[1;33m'", \\"$'\e[0;31m'J$'\e[0;33m'~~~$'\e[1;33m'~~$'\e[0;33m'"     \\"
echo "  (-"$'\e[1;33m'"\\)"$'\e[0;31m'"\\="$'\e[0;33m'"|"$'\e[1;33m'"\\\\\\"$'\e[0;33m'~~$'\e[1;33m'~~$'\e[0;33m'"       L_"$'\e[1;33m'_$'\e[0;33m'
echo "  ("$'\e[0;31m'"\\"$'\e[0;33m'"\\)  ("$'\e[1;33m'"\\"$'\e[0;33m'"\\\\)"$'\e[0;31m'_$'\e[1;33m'"           \\=="$'\e[0;33m'__$'\e[0;31m'
echo "   \\V    "$'\e[0;33m'"\\\\"$'\e[0;31m'"\\) =="$'\e[0;33m'=_____"   "$'\e[1;33m'"\\\\\\\\"$'\e[0;33m'"\\\\"$'\e[0;31m'
echo "          \\V)     \\_) "$'\e[0;33m'"\\\\"$'\e[1;33m'"\\\\JJ\\"$'\e[0;33m'J"\\)"$'\e[0;31m'
echo "                      /"$'\e[0;33m'J$'\e[1;33m'"\\"$'\e[0;33m'J$'\e[0;31m'T"\\"$'\e[0;33m'JJJ$'\e[0;31m'J")"
echo "                      (J"$'\e[0;33m'JJ$'\e[0;31m'"| \\UUU)"
echo "                       (UU)"

echo $'\e[0m'

CYAN='\033[0;36m'
RESET='\033[0m'
echo -e "${CYAN}Made with ❤️ by Koi | Nexus Node Runner V1.0${RESET}"
echo ""

install_dependencies() {
    sudo apt update
    sudo apt install -y build-essential pkg-config libssl-dev unzip screen expect
    sudo apt install -y protobuf-compiler
}

fix_protoc_error() {
    wget https://github.com/protocolbuffers/protobuf/releases/download/v29.3/protoc-29.3-linux-x86_64.zip
    unzip protoc-29.3-linux-x86_64.zip -d protoc-29.3
    sudo mv protoc-29.3/bin/protoc /usr/local/bin/
    sudo mv protoc-29.3/include/* /usr/local/include/
    export PATH="/usr/local/bin:$PATH"
    echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
    if [ -f /usr/bin/protoc ]; then
        sudo mv /usr/bin/protoc /usr/bin/protoc_old
    fi
}

setup_node() {
    install_dependencies
    
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    . "$HOME/.cargo/env"
    . "$HOME/.cargo/env"
    rustup target add riscv32i-unknown-none-elf
    fix_protoc_error
    
    echo "Node setup complete!"
}

run_node() {
    install_dependencies
    screen -dmS nexus_node bash -c 'expect -c "
        spawn bash -c \"curl https://cli.nexus.xyz/ | sh\"
        expect \"Do you agree to the Nexus Beta Terms of Use (https://nexus.xyz/terms-of-use)? (Y/n)\"
        send \"Y\r\"
        expect \"This node is already connected to an account using node id:*\"
        expect \"Do you want to use the existing user account? (y/n)\"
        send \"y\r\"
        expect eof
    "; exec bash'
    
    echo "Nexus Node is running in a screen session named 'nexus_node'"
    echo "To attach to the session, use: screen -r nexus_node"
    echo "To detach from the session (once attached), press: Ctrl+A, then D"
}

echo "Please select an option:"
echo "1) Set up a node"
echo "2) Run a node"
echo ""
read -p "Enter your choice (1 or 2): " choice

case $choice in
    1)
        setup_node
        ;;
    2)
        run_node
        ;;
    *)
        echo "Invalid choice. Please run the script again and select 1 or 2."
        exit 1
        ;;
esac

echo "Thank you for using Nexus Node Runner!"