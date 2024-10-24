"""
Sunsky-old_photo_fixer_openCV - 旧照片修复工具-CV版（还在学习中，并不保证好用）

用法：
- 运行脚本后，脚本将自动读取指定路径下的图片，进行去噪和锐化处理。
- 处理后的图片将显示在屏幕上，并保存在指定的目录中。

功能：
- 使用Pillow库读取和处理图片，将图片转换为灰度图。
- 使用OpenCV库进行去噪和锐化处理，利用双边滤波器去除噪声，使用自定义卷积核进行锐化。
- 使用Matplotlib库显示原始图片和处理后的图片。
- 脚本提供了一个主函数`main`，用于执行整个照片增强流程。

示例：
- 假设待增强的图片存放在"python/photo/old_photo_fixer/old_photo"目录下，文件名为"test_old_photo.jpeg"。
- 脚本将读取该图片，进行去噪和锐化处理，并将处理后的图片保存在"python/photo/old_photo_fixer/fixed_photo"目录下。

注意：
- 运行脚本前，请确保已经安装了Pillow、NumPy、Matplotlib和OpenCV库，可以通过pip安装：pip install pillow numpy matplotlib opencv-python。
- 请确保脚本中的图片路径和保存路径正确无误，否则可能导致脚本运行失败。
- 脚本中的去噪和锐化参数（如双边滤波的参数和锐化卷积核）可以根据需要进行调整，以达到最佳的视觉效果。
- 脚本在保存处理后的图片时，会检查同名文件是否存在。如果存在，将提示用户是否覆盖。用户可以选择覆盖或取消保存。
- 请确保系统的Pillow、NumPy、Matplotlib和OpenCV库是最新版本，以获得最佳的增强效果和兼容性。
"""

import numpy as np
import matplotlib.pyplot as plt
import cv2
from PIL import Image, ImageFilter
import os

# 读取图片并转换为灰度图
def load_image(image_path):
    img = Image.open(image_path)
    return img.convert("L")

# OpenCV 去噪处理
def denoise_image(image):
    img_array = np.array(image)
    # 使用OpenCV的双边滤波去噪
    denoised_img = cv2.bilateralFilter(img_array, d=9, sigmaColor=75, sigmaSpace=75)
    return Image.fromarray(denoised_img, "L")

# OpenCV 锐化处理
def sharpen_image(image):
    img_array = np.array(image)
    # 定义锐化的卷积核
    kernel = np.array([[0, -1, 0],
                       [-1, 5, -1],
                       [0, -1, 0]])
    sharpened_img = cv2.filter2D(img_array, -1, kernel)
    return Image.fromarray(sharpened_img, "L")

# 显示图片
def display_images(original, processed):
    plt.figure(figsize=(10, 5))
    plt.subplot(1, 2, 1)
    plt.imshow(original, cmap="gray")
    plt.title("old")
    plt.axis("off")
    
    plt.subplot(1, 2, 2)
    plt.imshow(processed, cmap="gray")
    plt.title("fixed")
    plt.axis("off")
    
    plt.show()

# 保存修复后的图片
def save_image(image, original_path):
    fixed_dir = "python/photo/old_photo_fixer/fixed_photo"
    # 确保目录存在
    os.makedirs(fixed_dir, exist_ok=True)
    # 获取原文件名并创建新文件名
    base_name = os.path.basename(original_path)
    file_name, ext = os.path.splitext(base_name)
    new_file_name = f"fixed-{file_name}{ext}"
    save_path = os.path.join(fixed_dir, new_file_name)
    
    # 检查是否存在同名文件
    if os.path.exists(save_path):
        overwrite = input(f"{save_path} 文件已存在，是否覆盖? (y/n): ")
        if overwrite.lower() != 'y':
            print("文件未保存。")
            return
            
    image.save(save_path)
    print(f"修复后的图片已保存为：{save_path}")

# 主程序
def main():
    # 设置图片路径
    image_path = os.path.join("python/photo/old_photo_fixer/old_photo", "test_old_photo.jpeg")  # 替换为你的图片文件名

    # 加载图片
    image = load_image(image_path)

    # 对图片进行去噪处理
    denoised_image = denoise_image(image)

    # 对图片进行锐化处理
    sharpened_image = sharpen_image(denoised_image)

    # 显示原始图片和修复后的图片
    display_images(image, sharpened_image)

    # 保存修复后的图片
    save_image(sharpened_image, image_path)

if __name__ == "__main__":
    main()
