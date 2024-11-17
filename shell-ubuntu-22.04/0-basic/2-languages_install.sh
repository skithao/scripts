#!/bin/bash

# 颜色定义
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
RESET=$(tput sgr0)

# 菜单函数
show_menu() {
    echo -e "${YELLOW}
    ==================== 程序语言环境安装器 ===================="
    echo -e "1. 安装 C 语言环境"
    echo -e "2. 安装 C++ 语言环境"
    echo -e "3. 安装 Python 环境"
    echo -e "4. 安装 Rust 环境"
    echo -e "5. 安装所有环境"
    echo -e "${RESET}请输入你的选择 (1-5):"
}

# 安装函数
install_environment() {
    local language=$1
    echo -e "${GREEN}正在安装 ${language} 环境...${RESET}"
    case $language in
        "C") sudo apt update && sudo apt install -y build-essential ;;
        "C++") sudo apt update && sudo apt install -y build-essential ;;
        "Python") sudo apt update && sudo apt install -y python3 python3-dev ;;
        "Rust") curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh ;;
    esac
}

# 主逻辑
while true; do
    show_menu
    read -r choice
    case $choice in
        1) install_environment "C";;
        2) install_environment "C++";;
        3) install_environment "Python";;
        4) install_environment "Rust";;
        5) 
            install_environment "C"
            install_environment "C++"
            install_environment "Python"
            install_environment "Rust"
            echo -e "${GREEN}所有环境已安装完毕。${RESET}"
            ;;
        *) echo -e "${RED}无效选择，请重新尝试。${RESET}";;
    esac
    # 更新环境变量
    source ~/.bashrc
    # 更新软件源
    sudo apt update
    sudo apt upgrade -y
        echo -e "${CYAN}您想要安装另一个环境吗？ (y/n)${RESET}"
    read -r confirm
    if [[ $confirm != [Yy] ]]; then
        # 清屏
        clear
        break
    fi
done

echo -e "${WHITE}感谢使用程序语言环境安装器。${RESET}"
