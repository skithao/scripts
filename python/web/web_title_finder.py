"""
Sunsky-web_title_finder 网页标题内容抓取工具

用法：

    运行脚本后，输入要访问的URL。
    脚本将发送HTTP GET请求到指定的URL，并获取网页内容。
    脚本使用BeautifulSoup库解析HTML文档，并提取网页中的多级标题（h1到h6）。
    提取的标题将以树状结构打印出来，显示标题的层级和文本内容。

示例：

    用户输入URL：https://github.com/skithao
    脚本将输出该网页中所有h1到h6标签的标题，以及它们的文本内容。

功能：

    该脚本使用requests库发送HTTP请求，获取网页内容。
    使用BeautifulSoup库解析HTML文档，提取网页中的多级标题。
    脚本提供了一个函数print_headings，用于查找并打印多级标题。
    打印的标题内容将根据其在HTML文档中的层级进行缩进，以便用户更好地理解网页结构。

注意：

    运行脚本前，请确保已经安装了requests和beautifulsoup4库，可以通过pip安装：pip install requests beautifulsoup4。
    如果遇到网络问题导致网页内容获取失败，请检查URL的合法性，并在网络连接稳定的情况下重试。
    如果脚本无法解析指定的URL（如https://github.com/skithao），可能是因为网络问题或链接本身的问题。请检查链接的合法性，并在网络连接稳定的情况下重试。
    脚本仅适用于文本内容的提取，对于网页中的图片、视频等内容，需要使用其他方法进行抓取。
    请不要在未经网站所有者许可的情况下抓取网页内容，这可能违反版权法规。
"""


import requests  # 导入请求库，用于发送HTTP请求
from bs4 import BeautifulSoup  # 从bs4导入BeautifulSoup，用于解析HTML文档

# 从命令行获取用户输入的URL
url = input("请输入要访问的URL: ")

# 发送GET请求，获取网页内容
response = requests.get(url)

# 使用BeautifulSoup解析获取的网页内容
soup = BeautifulSoup(response.content, "html.parser")

# 定义函数，用于查找并以树状结构打印多级标题
def print_headings(soup):
    for i in range(1, 7):  # 从h1到h6
        headings = soup.find_all(f'h{i}')  # 查找所有的h标签
        for heading in headings:
            indent = "    " * (i - 1)  # 根据标题级别设置缩进
            print(f"{indent}{heading.name}: {heading.get_text(strip=True)}")  # 打印标签名和文本内容

# 调用函数打印多级标题
print_headings(soup)
