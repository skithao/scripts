#!/bin/bash

# 脚本说明：
# 该脚本用于更新系统的包列表、升级所有可升级的包、自动移除不再需要的包、清理下载的包文件，并显示系统信息。
# 脚本使用了 whiptail 工具来显示提示框，并使用了 sudo 命令来执行需要管理员权限的操作。
# 脚本使用了 neofetch 工具来显示系统信息。

# 检查所需工具是否安装
REQUIRED_TOOLS=("whiptail" "sudo" "apt-get" "neofetch")

check_command() {
    if ! command -v "$1" &> /dev/null; then
        return 1
    fi
    return 0
}

install_tool() {
    local TOOL="$1"
    whiptail --title "缺少工具" --msgbox "$TOOL 没有安装。请安装它以继续。" 8 60
    echo "您可以使用以下命令安装 $TOOL："
    echo "sudo apt-get install $TOOL"
    
    # 询问用户是否现在安装该工具
    if whiptail --title "安装 $TOOL" --yesno "是否现在安装 $TOOL ?" 8 60; then
        sudo apt-get install "$TOOL" || {
            whiptail --title "安装失败" --msgbox "$TOOL 安装失败，请检查错误信息。" 8 60
            whiptail --title "错误信息" --textbox /var/log/apt/history.log 20 80
            exit 1
        }
    else
        exit 1
    fi
}

# 检查工具安装情况
for TOOL in "${REQUIRED_TOOLS[@]}"; do
    check_command "$TOOL" || install_tool "$TOOL"
done

# 检查用户权限
if [ "$(id -u)" != "0" ]; then
    PASSWORD=$(whiptail --title "权限请求" --inputbox "更新需要sudo权限，请输入您的密码：" 8 60 3>&1 1>&2 2>&3) || exit 1
    echo "$PASSWORD" | sudo -S true || {
        whiptail --title "错误" --msgbox "sudo权限验证失败，请检查密码是否正确。" 8 60
        exit 1
    }
else
    whiptail --title "提示" --msgbox "当前用户是root，不需要sudo权限。" 8 60
fi

# 更新系统的包列表
if whiptail --title "更新包列表" --yesno "正在更新包列表，是否继续？" 8 60; then
    echo "$PASSWORD" | sudo -S apt-get update
else
    exit 1
fi

# 升级所有可升级的包
if whiptail --title "升级包" --yesno "正在升级所有可升级的包，是否继续？" 8 60; then
    echo "$PASSWORD" | sudo -S apt-get upgrade -y
else
    exit 1
fi

# 可选：自动移除不再需要的包
if whiptail --title "移除不需要的包" --yesno "正在自动移除不再需要的包，是否继续？" 8 60; then
    echo "$PASSWORD" | sudo -S apt-get autoremove -y
fi

# 可选：清理下载的包文件
if whiptail --title "清理包文件" --yesno "正在清理下载的包文件，是否继续？" 8 60; then
    echo "$PASSWORD" | sudo -S apt-get clean
fi

whiptail --title "完成" --msgbox "系统更新完成。" 8 60

# 显示系统信息
if whiptail --title "显示系统信息" --yesno "是否要查看系统信息？" 8 60; then
    neofetch
else
    whiptail --title "提示" --msgbox "您选择不查看系统信息。" 8 60
fi
