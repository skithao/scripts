#!/bin/bash

# 脚本说明：
# 该脚本用于在 Ubuntu 22.04 上安装常用编程语言环境。
# 脚本会提示用户选择要安装的语言环境，并安装相应的环境。
# 脚本会安装以下语言环境：
# - C
# - C++
# - Java
# - Python
# - Rust

# 定义默认版本
DEFAULT_C_VERSION="gcc-11"
DEFAULT_CPP_VERSION="g++-11"
DEFAULT_JAVA_VERSION="openjdk-11-jdk"
DEFAULT_PYTHON_VERSION="python3.10"
DEFAULT_RUST_VERSION="rustc 1.62.1"

# 安装语言环境的函数
install_language() {
    language=$1
    version=$2

    if (whiptail --yesno "是否安装 $language $version ?" 8 45) then
        echo "正在安装 $language..."
        sudo apt update
        if [[ $language == "C" || $language == "C++" ]]; then
            sudo apt install -y $version
        elif [[ $language == "Java" ]]; then
            sudo apt install -y $version
        elif [[ $language == "Python" ]]; then
            sudo apt install -y $version
        elif [[ $language == "Rust" ]]; then
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        else
            whiptail --msgbox "未知语言：$language" 8 45
            return 1
        fi
        whiptail --msgbox "$language 安装完成。" 8 45
    else
        whiptail --msgbox "跳过 $language 的安装。" 8 45
    fi
}

# 显示欢迎信息
whiptail --msgbox "欢迎使用一键部署脚本" 8 45

# 选择要安装的语言环境
options=("C" "C++" "Java" "Python" "Rust" "全部" "退出")
choice=$(whiptail --menu "请选择你想要安装的语言环境：" 15 60 7 "${options[@]}" 3>&1 1>&2 2>&3)

case $choice in
    "C")
        install_language "C" "$DEFAULT_C_VERSION"
        ;;
    "C++")
        install_language "C++" "$DEFAULT_CPP_VERSION"
        ;;
    "Java")
        install_language "Java" "$DEFAULT_JAVA_VERSION"
        ;;
    "Python")
        install_language "Python" "$DEFAULT_PYTHON_VERSION"
        ;;
    "Rust")
        install_language "Rust" "$DEFAULT_RUST_VERSION"
        ;;
    "全部")
        install_language "C" "$DEFAULT_C_VERSION"
        install_language "C++" "$DEFAULT_CPP_VERSION"
        install_language "Java" "$DEFAULT_JAVA_VERSION"
        install_language "Python" "$DEFAULT_PYTHON_VERSION"
        install_language "Rust" "$DEFAULT_RUST_VERSION"
        ;;
    "退出")
        whiptail --msgbox "退出脚本。" 8 45
        exit 0
        ;;
    *)
        whiptail --msgbox "无效的选项，请重新运行脚本。" 8 45
        exit 1
        ;;
esac

# 脚本结束
whiptail --msgbox "脚本执行完毕。" 8 45
