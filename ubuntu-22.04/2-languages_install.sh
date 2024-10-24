#!/bin/bash

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

    read -p "是否安装 $language $version (y/n)？" install_confirmation
    if [[ $install_confirmation =~ ^[Yy]$ ]]; then
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
            echo "未知语言：$language"
            return 1
        fi
        echo "$language 安装完成。"
    else
        echo "跳过 $language 的安装。"
    fi
}

# 显示欢迎信息
echo "欢迎使用一键部署脚本"
echo "请选择你想要安装的语言环境："
echo "1) C"
echo "2) C++"
echo "3) Java"
echo "4) Python"
echo "5) Rust"
echo "6) 全部"
echo "7) 退出"
read -p "请输入你的选择（1-7）： " choice

case $choice in
    1)
        install_language "C" "$DEFAULT_C_VERSION"
        ;;
    2)
        install_language "C++" "$DEFAULT_CPP_VERSION"
        ;;
    3)
        install_language "Java" "$DEFAULT_JAVA_VERSION"
        ;;
    4)
        install_language "Python" "$DEFAULT_PYTHON_VERSION"
        ;;
    5)
        install_language "Rust" "$DEFAULT_RUST_VERSION"
        ;;
    6)
        install_language "C" "$DEFAULT_C_VERSION"
        install_language "C++" "$DEFAULT_CPP_VERSION"
        install_language "Java" "$DEFAULT_JAVA_VERSION"
        install_language "Python" "$DEFAULT_PYTHON_VERSION"
        install_language "Rust" "$DEFAULT_RUST_VERSION"
        ;;
    7)
        echo "退出脚本。"
        exit 0
        ;;
    *)
        echo "无效的选项，请重新运行脚本。"
        exit 1
        ;;
esac

# 脚本结束
echo "脚本执行完毕。"