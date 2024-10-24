"""
Sunsky-web_internet_speed - 互联网速度测试工具

用法：
- 运行脚本后，将显示一个命令行界面，提供多种测试选项。
- 用户可以通过输入数字选择要进行的测试类型，包括下载速度、上传速度、网络延迟、列出所有服务器、选择特定服务器进行测试、以字节为单位显示速度，或退出程序。
- 脚本将执行相应的网络测试，并显示测试结果。

功能：
- 使用speedtest-cli库进行网络速度测试，该库提供了一个简单的命令行界面来测试网络速度。
- 用户可以选择测试下载速度、上传速度和网络延迟。
- 用户可以查看所有可用的测试服务器，并选择一个特定服务器进行测试。
- 用户可以选择以字节为单位显示速度结果，而不是默认的Mbps。
- 脚本提供了一个循环菜单，允许用户连续进行多个测试，直到选择退出。

示例：
- 用户输入1，脚本将测试并显示下载速度。
- 用户输入2，脚本将测试并显示上传速度。
- 用户输入3，脚本将测试并显示网络延迟。
- 用户输入4，脚本将列出所有可用的测试服务器。
- 用户输入5，脚本将允许用户输入服务器ID，并在该服务器上进行测试。
- 用户输入6，脚本将测试并显示以字节为单位的速度结果。
- 用户输入7，脚本将退出。

注意：
- 运行脚本前，请确保已经安装了speedtest-cli库，可以通过pip安装：pip install speedtest-cli。
- 网络测试结果可能受到多种因素的影响，包括网络拥堵、服务器负载和用户的网络配置。
- 测试结果仅供参考，实际网络速度可能会有所不同。
- 选择特定服务器进行测试时，请输入正确的服务器ID，否则测试可能无法进行。
- 脚本在测试网络速度时可能会产生一定的网络流量，请注意您的网络使用限额。
- 脚本运行时，请不要关闭命令行界面，以免测试中断。
"""

import sys
import speedtest

def main():
    # 创建Speedtest对象
    st = speedtest.Speedtest()

    # 显示命令行界面
    print("Sunsky_speedtest - 互联网速度测试工具")
    print("1. 测试下载速度")
    print("2. 测试上传速度")
    print("3. 测试网络延迟")
    print("4. 列出所有服务器")
    print("5. 选择特定服务器进行测试")
    print("6. 以字节为单位显示速度")
    print("7. 退出")

    while True:
        try:
            choice = int(input("请输入你的选择 (1-7): "))
            if choice == 1:
                test_download_speed(st)
            elif choice == 2:
                test_upload_speed(st)
            elif choice == 3:
                test_ping_speed(st)
            elif choice == 4:
                list_servers(st)
            elif choice == 5:
                test_specific_server(st)
            elif choice == 6:
                show_results_in_bytes(st)
            elif choice == 7:
                print("正在退出...")
                sys.exit()
            else:
                print("无效选择。请输入一个 1 到 7 之间的数字。")
        except ValueError:
            print("无效输入。请输入一个数字。")

def test_download_speed(st):
    st.download()
    print(f"下载速度: {st.results.download} Mbps")

def test_upload_speed(st):
    st.upload()
    print(f"上传速度: {st.results.upload} Mbps")

def test_ping_speed(st):
    st.results.ping = st.ping()
    print(f"网络延迟: {st.results.ping} ms")

def list_servers(st):
    print("列出所有服务器...")
    st.get_servers()
    for server in st.results.servers:
        print(f"ID: {server['id']}, 名称: {server['name']}, 国家: {server['country']}, 赞助商: {server['sponsor']}")

def test_specific_server(st):
    server_id = input("请输入要测试的服务器 ID: ")
    st.select_best_server()  # 这将自动选择最佳服务器
    print(f"正在测试服务器 ID {server_id}...")
    st.download()
    st.upload()
    print(f"服务器 ID {server_id} - 网络延迟: {st.results.ping} ms, 下载速度: {st.results.download} Mbps, 上传速度: {st.results.upload} Mbps")

def show_results_in_bytes(st):
    st.download()
    st.upload()
    print(f"下载速度: {st.results.download / 8} MB/s")
    print(f"上传速度: {st.results.upload / 8} MB/s")

if __name__ == "__main__":
    main()
