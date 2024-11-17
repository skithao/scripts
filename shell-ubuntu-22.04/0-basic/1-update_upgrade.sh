#!/bin/bash

# 脚本说明：
# 该脚本用于更新系统的包列表、升级所有可升级的包、自动移除不再需要的包、清理下载的包文件，并显示系统信息。

# 检查所需工具是否安装
REQUIRED_TOOLS=("sudo" "apt-get" "neofetch")

check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "$1 没有安装。请安装它以继续。"
        echo "您可以使用以下命令安装 $1："
        echo "sudo apt-get install $1"
        read -p "是否现在安装 $1? (y/n): " answer
        if [[ $answer == "y" ]]; then
            sudo apt-get install "$1" || {
                echo "$1 安装失败，请检查错误信息。"
                exit 1
            }
        else
            exit 1
        fi
    fi
}

# 检查工具安装情况
for TOOL in "${REQUIRED_TOOLS[@]}"; do
    check_command "$TOOL"
done

# 检查用户权限
if [ "$(id -u)" != "0" ]; then
    read -sp "更新需要sudo权限，请输入您的密码：" PASSWORD
    echo "$PASSWORD" | sudo -S true || {
        echo "sudo权限验证失败，请检查密码是否正确。"
        exit 1
    }
else
    echo "当前用户是root，不需要sudo权限。"
fi

# 更新系统的包列表
read -p "正在更新包列表，是否继续？(y/n): " answer
if [[ $answer == "y" ]]; then
    echo "$PASSWORD" | sudo -S apt-get update
else
    exit 1
fi

# 升级所有可升级的包
read -p "正在升级所有可升级的包，是否继续？(y/n): " answer
if [[ $answer == "y" ]]; then
    echo "$PASSWORD" | sudo -S apt-get upgrade -y
else
    exit 1
fi

# 可选：自动移除不再需要的包
read -p "正在自动移除不再需要的包，是否继续？(y/n): " answer
if [[ $answer == "y" ]]; then
    echo "$PASSWORD" | sudo -S apt-get autoremove -y
fi

# 可选：清理下载的包文件
read -p "正在清理下载的包文件，是否继续？(y/n): " answer
if [[ $answer == "y" ]]; then
    echo "$PASSWORD" | sudo -S apt-get clean
fi

echo "系统更新完成。"

# 显示系统信息
read -p "是否要查看系统信息？(y/n): " answer
if [[ $answer == "y" ]]; then
    neofetch
else
    echo "您选择不查看系统信息。"
fi
