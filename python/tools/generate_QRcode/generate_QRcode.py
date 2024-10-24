"""
Sunsky-QRcodes 生成二维码的命令行工具

用法：
- 生成网址的二维码：
  输入1，然后输入网址，例如：https://github.com/skithao

- 生成文本的二维码：
  输入2，然后输入文本内容，例如："Hello, world!"

- 生成本地图片的二维码（因为保存的是路径而不在云端，所以扫描二维码后无法直接打开图片）：
  输入3，然后输入图片路径和名称，例如：test_photos/test_photo.png

- 添加图片背景：
  在选择生成二维码类型后，可以选择是否添加图片背景。如果选择添加，请输入背景图片的路径。
  例如：test_photos/test_photo.png

功能：
- 该脚本使用 MyQR 库生成二维码，支持生成网址、文本和本地图片的二维码。
- 用户可以选择是否将特定图片作为二维码的背景，或者将特定图片作为二维码扫描出来的内容。
- 二维码将被保存为 GIF 格式，并保存在当前目录下的 'QRs' 文件夹中。
- 二维码文件的命名格式为 'qr_code_YYYYMMDD_HHMMSS.gif'，其中时间戳表示生成时间。

注意：
- 运行脚本前，请确保已经安装了 MyQR 库，可以通过 pip 安装：pip install MyQR。
- 如果遇到网络问题导致链接解析失败，请检查链接的合法性，并在网络连接稳定的情况下重试。
- 请不要在公共场合展示生成的二维码，二维码包含个人信息，泄露后可能导致个人隐私泄露。
"""

from MyQR import myqr
import os
from datetime import datetime

def generate_qr(content_type, content, background_image_path=None):
    # 确定保存路径和文件名称
    output_dir = './QRs'
    os.makedirs(output_dir, exist_ok=True)  # 创建QRs文件夹（如果不存在）
    
    # 生成日期字符串
    date_str = datetime.now().strftime("%Y%m%d_%H%M%S")
    save_name = f"qr_code_{date_str}.gif"

    # 生成二维码
    version, level, qr_name = myqr.run(
        words=content,
        version=1,
        level='H',
        picture=background_image_path,  # 使用 picture 参数设置背景图片
        colorized=True,
        contrast=1.0,
        brightness=1.0,
        save_name=save_name,
        save_dir=output_dir
    )
    print(f"二维码已保存为 {os.path.join(output_dir, save_name)}")

def main():
    print("选择二维码内容类型：")
    print("1. 网址 (URL)")
    print("2. 文本 (Text)")
    print("3. 图片 (Image)")
    
    content_type = input("请输入选项数字 (1-3)：").strip()
    
    # 将数字选项转换为内容类型
    content_types = {"1": "url", "2": "text", "3": "image"}
    if content_type not in content_types:
        print("无效的选项，请重新运行程序。")
        return
    
    content_type = content_types[content_type]
    
    # 用户输入内容
    if content_type in ['url', 'text']:
        content = input(f"请输入{content_type}内容：").strip()
    else:
        content = input("请输入图片内容（包括路径和文件名）：").strip()
    
    print("是否要添加图片背景？输入 'y' 表示是，其他表示否：")
    add_background = input().strip().lower()
    background_image_path = None
    if add_background == 'y':
        background_image_path = input("请输入图片背景路径（包括文件名）：").strip()
    
    generate_qr(content_type, content, background_image_path)

if __name__ == "__main__":
    main()