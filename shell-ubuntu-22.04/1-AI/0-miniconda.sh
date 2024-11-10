#!/bin/bash

# conda 环境配置脚本

# 检查是否安装指定的程序
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "未找到 $1，请先安装它。"
        echo "您可以使用以下命令安装 $1："
        echo "sudo apt update && sudo apt install $1 -y"
        if (whiptail --yesno "您是否要安装 $1 ？" 10 30); then
            sudo apt update && sudo apt install "$1" -y
        else
            exit 1
        fi
    fi
}

# 检查程序是否安装
check_command python3
check_command whiptail

# 检查 conda 是否安装
check_conda() {
    if command -v conda &> /dev/null; then
        echo "conda已安装，版本号：$(conda --version)"
    else
        echo "conda未安装，请根据提示完成安装"
    fi
}

install_miniconda() {
    whiptail --title "当前功能：安装 Miniconda"
    path=$(whiptail --inputbox "请输入路径（默认路径为当前路径）：" 10 60 "$(pwd)" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
        return  # 用户取消
    fi
    cd "$path" || { whiptail --msgbox "无效路径，无法切换目录。" 10 30; return; }
    
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    if [ $? -ne 0 ]; then
        whiptail --msgbox "下载 Miniconda 失败，请检查网络连接。" 10 30
        return
    fi
    
    chmod +x Miniconda3-latest-Linux-x86_64.sh
    ./Miniconda3-latest-Linux-x86_64.sh -b -p "$HOME/miniconda3" # -b: batch mode, -p: prefix path
    if [ $? -ne 0 ]; then
        whiptail --msgbox "Miniconda 安装失败。" 10 30
        return
    fi
    
    whiptail --msgbox "Miniconda 安装完成。" 10 30
}

configure_env() {
    whiptail --title "当前功能：配置环境变量"
    echo "export PATH=\$HOME/miniconda3/bin:\$PATH" >> ~/.bashrc
    source ~/.bashrc
    whiptail --msgbox "环境变量配置完成。" 10 30
}

create_conda_env() {
    whiptail --msgbox "当前功能：创建 conda 环境" 10 40

    envname=$(whiptail --inputbox "请输入环境名称（默认名称为 base）：" 10 60 "base" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
        return  # 用户取消
    fi

    pythonversion=$(whiptail --inputbox "请输入 python 版本（默认版本为 3.8）：" 10 60 "3.8" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
        return  # 用户取消
    fi

    conda create -n "${envname:-base}" python="${pythonversion:-3.8}" -y 2> error_log.txt
    if [ $? -ne 0 ]; then
        error_message=$(< error_log.txt)
                whiptail --msgbox "conda创建失败，请勿在安装过程点击 Ctrl + C，若持续出现此问题，请在 GitHub 提交 issue。\n\n具体错误信息：\n\nCond
aError: KeyboardInterrupt" 20 60

        return
    fi
    
    whiptail --msgbox "环境 '${envname:-base}' 创建完成，使用 Python ${pythonversion:-3.8}。" 10 60
}

activate_conda_env() {
    whiptail --title "当前功能：激活 conda 环境"
    existing_envs=$(conda env list | awk 'NR>2 {print $1}')
    if [ -z "$existing_envs" ]; then
        whiptail --msgbox "没有可用的 conda 环境。" 10 30
        return
    fi
    
    envname=$(whiptail --inputbox "想要激活哪个环境？（可用环境：$existing_envs）\n（默认环境为 base）：" 10 60 "base" 3>&1 1>&2 2>&3)
    
    if [ $? -ne 0 ]; then
        return  # 用户取消
    fi

    if ! conda env list | grep -q "${envname:-base}"; then
        if (whiptail --yesno "您输入的conda环境不存在，是否创建新环境？" 10 30); then
            create_conda_env
        else
            return
        fi
    fi

    conda activate "${envname:-base}"
    whiptail --msgbox "环境 '${envname:-base}' 已激活。" 10 30
}

delete_conda_env() {
    whiptail --title "当前功能：删除 conda 环境"
    existing_envs=$(conda env list | awk 'NR>2 {print $1}')
    if [ -z "$existing_envs" ]; then
        whiptail --msgbox "没有可用的 conda 环境。" 10 30
        return
    fi
    
    envname=$(whiptail --inputbox "想要删除哪个环境？（可用环境：$existing_envs）\n（默认环境可以是 base）：" 10 60 "base" 3>&1 1>&2 2>&3)
    
    if [ $? -ne 0 ]; then
        return  # 用户取消
    fi

    if conda env list | grep -q "${envname:-base}"; then
        if (whiptail --yesno "您确认要删除环境 '${envname:-base}' 吗？" 10 30); then
            conda remove -n "${envname:-base}" --all -y
            whiptail --msgbox "环境 '${envname:-base}' 已删除。" 10 30
        fi
    else
        whiptail --msgbox "环境 '${envname:-base}' 不存在。" 10 30
    fi
}

list_conda_packages() {
    whiptail --title "当前功能：列出 conda 环境中的已安装库"
    existing_envs=$(conda env list | awk 'NR>2 {print $1}')
    if [ -z "$existing_envs" ]; then
        whiptail --msgbox "没有可用的 conda 环境。" 10 30
        return
    fi
    
    envname=$(whiptail --inputbox "想要查看哪个环境的已安装库？（可用环境：$existing_envs）\n（默认环境为 base）：" 10 60 "base" 3>&1 1>&2 2>&3)
    
    if [ $? -ne 0 ]; then
        return  # 用户取消
    fi

    if ! conda env list | grep -q "${envname:-base}"; then
        whiptail --msgbox "环境 '${envname:-base}' 不存在。" 10 30
        return
    fi

    # 获取已安装库并格式化为表格
    packages=$(conda list -n "${envname:-base}" | awk 'NR>3 {print $1, $2, $3}' | column -t)

    # 创建临时文件
    temp_file=$(mktemp)
    echo -e "环境 '${envname:-base}' 中已安装的库：\n" > "$temp_file"
    echo "$packages" >> "$temp_file"

    # 使用 whiptail 显示文本框
    whiptail --textbox "$temp_file" 20 60

    # 删除临时文件
    rm "$temp_file"
}



# 主循环
while true; do
    check_conda_msg=$(check_conda)
    option=$(whiptail --title "SUNSKY-conda配置界面" --menu "\n$check_conda_msg\n选择功能：" 20 70 6 \
        "1." "安装 Miniconda" \
        "2." "配置环境变量" \
        "3." "创建 conda 环境" \
        "4." "激活 conda 环境" \
        "5." "删除 conda 环境" \
        "6." "列出 conda 环境中的已安装库" \
        "7." "退出"  3>&1 1>&2 2>&3)

    if [ $? -ne 0 ]; then
        if (whiptail --yesno "您确定要退出程序吗？" 10 30); then exit 0; fi
        continue
    fi

    case $option in
        "1.") install_miniconda ;;
        "2.") configure_env ;;
        "3.") create_conda_env ;;
        "4.") activate_conda_env ;;
        "5.") delete_conda_env ;;
        "6.") list_conda_packages ;;
        "7.") if (whiptail --yesno "您确定要退出程序吗？" 10 30); then exit 0; fi ;;
        *) whiptail --msgbox "无效选项，请重新选择。" 10 30 ;;
    esac
done
