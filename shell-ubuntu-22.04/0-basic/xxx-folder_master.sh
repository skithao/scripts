#! /bin/bash

# 脚本说明：
# 1. 文件夹操作
# 2. 文件操作
# 3. 权限操作

# 功能列表
function show_menu() {
    echo "文件管理工具"
    echo "选择一个操作："
    echo "1) 【文件夹操作】"
    echo "1.1) 创建文件夹"
    echo "1.2) 删除文件夹"
    echo "1.3) 移动文件夹"
    echo "1.4) 复制文件夹"
    echo "1.5) 查看文件夹"
    echo "1.6) 压缩文件夹"
    echo "1.7) 解压文件夹"
    echo "2) 【文件操作】"
    echo "2.1) 创建文件"
    echo "2.2) 删除文件"
    echo "2.3) 查看文件"
    echo "3) 【权限操作】"
    echo "3.1) 更改权限"
    echo "4) 退出"
}

# 执行操作并处理错误
function execute_action() {
    local action="$1"
    shift
    if ! $action "$@"; then
        echo "操作失败，请检查输入。"
    fi
}

# 操作函数
function create_folder() {
    mkdir "$1"
}

function delete_folder() {
    rmdir "$1"
}

function move_folder() {
    mv "$1" "$2"
}

function copy_folder() {
    cp -r "$1" "$2"
}

function view_folder() {
    ls "$1"
}

function compress_folder() {
    tar -czvf "$1.tar.gz" "$1"
}

function decompress_folder() {
    tar -xzvf "$1"
}

function create_file() {
    touch "$1"
}

function delete_file() {
    rm "$1"
}

function view_file() {
    cat "$1"
}

function change_permission() {
    chmod "$1" "$2"
}

while true; do
    show_menu
    read -p "请输入你的选择: " ACTION

    case $ACTION in
        1.1)
            read -p "请输入要创建的文件夹名称: " FOLDER_NAME
            execute_action create_folder "$FOLDER_NAME"
            ;;
        1.2)
            read -p "请输入要删除的文件夹名称: " FOLDER_NAME
            execute_action delete_folder "$FOLDER_NAME"
            ;;
        1.3)
            read -p "请输入要移动的文件夹名称: " SRC_FOLDER
            read -p "请输入目标路径: " DEST_FOLDER
            execute_action move_folder "$SRC_FOLDER" "$DEST_FOLDER"
            ;;
        1.4)
            read -p "请输入要复制的文件夹名称: " SRC_FOLDER
            read -p "请输入目标路径: " DEST_FOLDER
            execute_action copy_folder "$SRC_FOLDER" "$DEST_FOLDER"
            ;;
        1.5)
            read -p "请输入要查看的文件夹名称: " FOLDER_NAME
            execute_action view_folder "$FOLDER_NAME"
            ;;
        1.6)
            read -p "请输入要压缩的文件夹名称: " FOLDER_NAME
            execute_action compress_folder "$FOLDER_NAME"
            ;;
        1.7)
            read -p "请输入要解压的文件名: " FILE_NAME
            execute_action decompress_folder "$FILE_NAME"
            ;;
        2.1)
            read -p "请输入要创建的文件名称: " FILE_NAME
            execute_action create_file "$FILE_NAME"
            ;;
        2.2)
            read -p "请输入要删除的文件名称: " FILE_NAME
            execute_action delete_file "$FILE_NAME"
            ;;
        2.3)
            read -p "请输入要查看的文件名称: " FILE_NAME
            execute_action view_file "$FILE_NAME"
            ;;
        3.1)
            read -p "请输入新权限 (如 755): " PERMISSIONS
            read -p "请输入目标文件或文件夹: " TARGET
            execute_action change_permission "$PERMISSIONS" "$TARGET"
            ;;
        4)
            break
            ;;
        *)
            echo "无效选择，请重试。"
            ;;
    esac
done
