"""
Sunsky-old_photo_fixer_base - 旧照片修复工具-基础版（还在学习中，并不保证好用）

用法：
- 运行脚本后，脚本将自动读取指定路径下的旧照片，进行去噪和锐化处理。
- 处理后的照片将显示在屏幕上，并保存在指定的目录中。

功能：
- 使用Pillow库读取和处理图片，将图片转换为灰度图，进行去噪和锐化处理。
- 使用NumPy库进行数组操作，实现自定义的去噪算法。
- 使用Matplotlib库显示原始图片和处理后的图片。
- 脚本提供了一个主函数`main`，用于执行整个照片修复流程。

示例：
- 假设旧照片存放在"python/photo/old_photo_fixer/old_photo"目录下，文件名为"test_old_photo.jpeg"。
- 脚本将读取该照片，进行去噪和锐化处理，并将处理后的照片保存在"python/photo/old_photo_fixer/fixed_photo"目录下。

注意：
- 运行脚本前，请确保已经安装了Pillow、NumPy和Matplotlib库，可以通过pip安装：pip install pillow numpy matplotlib。
- 请确保脚本中的图片路径和保存路径正确无误，否则可能导致脚本运行失败。
- 脚本中的去噪算法是一个简化的版本，可能不适用于所有类型的旧照片。对于复杂的照片，可能需要更高级的算法或手动修复。
- 锐化处理的参数（半径和百分比）可以根据需要进行调整，以达到最佳的视觉效果。
- 脚本在保存处理后的照片时，会检查同名文件是否存在。如果存在，将提示用户是否覆盖。用户可以选择覆盖或取消保存。
- 请确保系统的Pillow、NumPy和Matplotlib库是最新版本，以获得最佳的修复效果和兼容性。
"""

import numpy as np
import matplotlib.pyplot as plt
from PIL import Image, ImageFilter
import os

# 读取图片并转换为灰度图
def load_image(image_path):
    img = Image.open(image_path)
    return img.convert("L")

# 对图片进行去噪处理
def denoise_image(image, weight=0.1):
    img_array = np.asarray(image, dtype=np.float32)
    out_array = img_array.copy()
    out_array[1:-1, 1:-1] = img_array[1:-1, 1:-1] * (1 - 4 * weight) + \
                            (img_array[:-2, 1:-1] + img_array[2:, 1:-1] + img_array[1:-1, :-2] + img_array[1:-1, 2:]) * weight
    return Image.fromarray(np.uint8(out_array), "L")

# 对图片进行锐化处理
def sharpen_image(image, radius=2, percent=200):
    return image.filter(ImageFilter.UnsharpMask(radius=radius, percent=percent, threshold=3))

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