#! /bin/bash

# 脚本说明(这个不建议用，是个人练手的脚本，建议自行命令行操作)：
# 1. 文件夹操作
# 2. 文件操作
# 3. 权限操作

# 功能列表
function show_menu() {
    whiptail --title "文件管理工具" --menu "选择一个操作" 15 60 14 \
    "1" "【文件夹操作】" \
    "1.1" "创建文件夹" \
    "1.2" "删除文件夹" \
    "1.3" "移动文件夹" \
    "1.4" "复制文件夹" \
    "1.5" "查看文件夹" \
    "1.6" "压缩文件夹" \
    "1.7" "解压文件夹" \
    "2" "【文件操作】" \
    "2.1" "创建文件" \
    "2.2" "删除文件" \
    "2.3" "查看文件" \
    "3" "【权限操作】" \
    "3.1" "更改权限" \
    "4" "退出" 3>&1 1>&2 2>&3
}

# 执行操作并处理错误
function execute_action() {
    local action="$1"
    shift
    if ! $action "$@"; then
        whiptail --msgbox "操作失败，请检查输入。" 10 60
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
    ACTION=$(show_menu)

    case $ACTION in
        1.1)
            FOLDER_NAME=$(whiptail --inputbox "请输入要创建的文件夹名称:" 10 60 --title "创建文件夹" 3>&1 1>&2 2>&3)
            execute_action create_folder "$FOLDER_NAME"
            ;;
        1.2)
            FOLDER_NAME=$(whiptail --inputbox "请输入要删除的文件夹名称:" 10 60 --title "删除文件夹" 3>&1 1>&2 2>&3)
            execute_action delete_folder "$FOLDER_NAME"
            ;;
        1.3)
            SRC_FOLDER=$(whiptail --inputbox "请输入要移动的文件夹名称:" 10 60 --title "移动文件夹" 3>&1 1>&2 2>&3)
            DEST_FOLDER=$(whiptail --inputbox "请输入目标路径:" 10 60 --title "移动文件夹" 3>&1 1>&2 2>&3)
            execute_action move_folder "$SRC_FOLDER" "$DEST_FOLDER"
            ;;
        1.4)
            SRC_FOLDER=$(whiptail --inputbox "请输入要复制的文件夹名称:" 10 60 --title "复制文件夹" 3>&1 1>&2 2>&3)
            DEST_FOLDER=$(whiptail --inputbox "请输入目标路径:" 10 60 --title "复制文件夹" 3>&1 1>&2 2>&3)
            execute_action copy_folder "$SRC_FOLDER" "$DEST_FOLDER"
            ;;
        1.5)
            FOLDER_NAME=$(whiptail --inputbox "请输入要查看的文件夹名称:" 10 60 --title "查看文件夹" 3>&1 1>&2 2>&3)
            execute_action view_folder "$FOLDER_NAME"
            ;;
        1.6)
            FOLDER_NAME=$(whiptail --inputbox "请输入要压缩的文件夹名称:" 10 60 --title "压缩文件夹" 3>&1 1>&2 2>&3)
            execute_action compress_folder "$FOLDER_NAME"
            ;;
        1.7)
            FILE_NAME=$(whiptail --inputbox "请输入要解压的文件名:" 10 60 --title "解压文件夹" 3>&1 1>&2 2>&3)
            execute_action decompress_folder "$FILE_NAME"
            ;;
        2.1)
            FILE_NAME=$(whiptail --inputbox "请输入要创建的文件名称:" 10 60 --title "创建文件" 3>&1 1>&2 2>&3)
            execute_action create_file "$FILE_NAME"
            ;;
        2.2)
            FILE_NAME=$(whiptail --inputbox "请输入要删除的文件名称:" 10 60 --title "删除文件" 3>&1 1>&2 2>&3)
            execute_action delete_file "$FILE_NAME"
            ;;
        2.3)
            FILE_NAME=$(whiptail --inputbox "请输入要查看的文件名称:" 10 60 --title "查看文件" 3>&1 1>&2 2>&3)
            execute_action view_file "$FILE_NAME"
            ;;
        3.1)
            PERMISSIONS=$(whiptail --inputbox "请输入新权限 (如 755):" 10 60 --title "更改权限" 3>&1 1>&2 2>&3)
            TARGET=$(whiptail --inputbox "请输入目标文件或文件夹:" 10 60 --title "更改权限" 3>&1 1>&2 2>&3)
            execute_action change_permission "$PERMISSIONS" "$TARGET"
            ;;
        4)
            break
            ;;
        *)
            whiptail --msgbox "无效选择，请重试。" 10 60
            ;;
    esac
done
