#!/bin/bash

# 定义依赖包
DEPENDENCIES=("unattended-upgrades" "lynis" "logwatch")

# 检查并安装依赖
echo "正在检查依赖..."
for dep in "${DEPENDENCIES[@]}"; do
    if ! dpkg -l | grep -qw "$dep"; then
        echo "$dep 未安装，正在安装..."
        apt-get update
        apt-get install -y "$dep"
    else
        echo "$dep 已安装。"
    fi
done

# 更新系统安全补丁
echo "正在检查系统更新..."
unattended-upgrade -d

# 扫描系统安全漏洞
echo "正在扫描系统安全漏洞..."
lynis audit system

# 检查系统日志中的可疑活动
echo "正在检查系统日志中的可疑活动..."
logwatch --mailto admin@example.com

echo "安全脚本执行完成。"