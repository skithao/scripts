#!/bin/bash

# 检查当前用户是否为root，如果不是则提示输入密码
if [ "$(id -u)" != "0" ]; then
    echo "需要管理员权限，正在尝试使用sudo..."
    # 更新sudo的授权时间，避免每次执行sudo命令时都输入密码
    # -v 选项会更新sudo的时间戳，如果用户输入正确的密码，那么在接下来的5分钟内不需要再次输入密码
    sudo -v
    # 检查sudo命令是否成功执行
    if [ $? -eq 0 ]; then
        echo "sudo权限验证成功。"
    else
        echo "sudo权限验证失败，请检查密码是否正确。" >&2
        exit 1
    fi
else
    echo "当前用户是root，不需要sudo权限。"
fi

# 更新系统的包列表
echo "正在更新包列表..."
sudo apt-get update

# 升级所有可升级的包
echo "正在升级所有可升级的包..."
sudo apt-get upgrade -y

# 可选：自动移除不再需要的包
echo "正在自动移除不再需要的包..."
sudo apt-get autoremove -y

# 可选：清理下载的包文件
echo "正在清理下载的包文件..."
sudo apt-get clean

echo "系统更新完成。"