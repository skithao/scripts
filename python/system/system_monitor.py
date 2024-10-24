"""
Sunsky-system_monitor - 系统资源监控工具

用法：
- 运行脚本后，用户可以输入监控间隔时间和持续时间。
- 脚本将根据用户输入的参数监控系统的CPU使用率、内存使用情况、磁盘IO和网络IO。
- 监控结果将实时打印在控制台上。

功能：
- 使用psutil库获取系统的CPU使用率、内存使用情况、磁盘IO和网络IO。
- 用户可以通过命令行输入自定义监控间隔时间和持续时间。
- 脚本提供了一个监控函数`monitor_system`，该函数按照指定的间隔和持续时间打印系统资源使用情况。
- 如果用户未输入有效的监控参数，脚本将使用默认值（间隔时间1秒，持续时间10秒）。

示例：
- 用户输入监控间隔时间为2秒，持续时间为20秒，脚本将每2秒打印一次系统资源使用情况，共持续20秒。

注意：
- 运行脚本前，请确保已经安装了psutil库，可以通过pip安装：pip install psutil。
- 脚本运行时，请不要关闭控制台窗口，以免监控中断。
- 监控系统资源可能会对系统性能产生一定影响，尤其是在高频率监控时。
- 脚本仅在控制台上打印监控结果，不会保存到文件中。
- 用户输入的监控间隔时间和持续时间应该是正整数，否则脚本将使用默认值。
- 请确保系统的psutil库是最新版本，以获得最佳的监控性能和兼容性。
"""

import psutil
import time
import argparse

def get_cpu_usage():
    # 获取CPU使用率
    cpu_usage = psutil.cpu_percent(interval=1)
    return cpu_usage

def get_memory_usage():
    # 获取内存使用情况
    memory = psutil.virtual_memory()
    return memory.percent

def get_disk_io():
    # 获取磁盘IO情况
    disk_io = psutil.disk_io_counters()
    return disk_io.read_bytes, disk_io.write_bytes

def get_network_io():
    # 获取网络IO情况
    network_io = psutil.net_io_counters()
    return network_io.bytes_sent, network_io.bytes_recv

def monitor_system(interval=1, duration=10):
    # 监控系统资源，interval为监控间隔时间（秒），duration为监控持续时间（秒）
    end_time = time.time() + duration
    while time.time() < end_time:
        cpu_usage = get_cpu_usage()
        memory_usage = get_memory_usage()
        read_bytes, write_bytes = get_disk_io()
        sent_bytes, recv_bytes = get_network_io()

        print(f"CPU Usage: {cpu_usage}%")
        print(f"Memory Usage: {memory_usage}%")
        print(f"Disk IO: Read {read_bytes}B, Write {write_bytes}B")
        print(f"Network IO: Sent {sent_bytes}B, Received {recv_bytes}B")
        print("-" * 40)

        # 等待间隔时间
        time.sleep(interval)

if __name__ == "__main__":
    # 提示用户输入监控间隔和持续时间
    try:
        interval = int(input("请输入监控间隔时间（秒），默认1秒: ") or 1)
        duration = int(input("请输入监控持续时间（秒），默认10秒: ") or 10)
    except ValueError:
        print("输入无效，使用默认值。")
        interval = 1
        duration = 10

    # 设置监控间隔和持续时间
    monitor_system(interval=interval, duration=duration)
