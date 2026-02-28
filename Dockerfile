# shiba_2.pdfを参考にCUDA 13.1.1を使用
FROM nvidia/cuda:13.1.1-cudnn-devel-ubuntu22.04

ENV LANG=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive

# shiba_2.pdfを参考に、画像・動画処理に必要なシステムパッケージをインストール
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential git wget ffmpeg libgl1 libglib2.0-0 \
    python3.10 python3-pip python3-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# pythonコマンドでpython3が動くようにする
RUN ln -s /usr/bin/python3 /usr/bin/python

# パッケージリストをコピー
COPY requirements.txt .

# PyTorchをインストール (安定のcu124を指定)
RUN pip install --no-cache-dir torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu124

# ComfyUIの要件とJupyterLabをインストール
RUN pip install --no-cache-dir -r requirements.txt

# Paperspace(8888)とComfyUI(8188)のポートを開放
EXPOSE 8888 8188 6006
