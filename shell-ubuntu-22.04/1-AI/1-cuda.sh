#! /bin/bash


: <<'EOF'
这是一个的脚本,主要包含以下内容：


EOF

# ------------------------配置 pytorch----------------------------
# pip(推荐)
./chsrc set pip

## conda 下载
conda install pytorch==2.1.2 torchvision==0.16.2 torchaudio==2.1.2 pytorch-cuda=12.1 -c pytorch -c nvidia -y

## pip 下载
# pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121