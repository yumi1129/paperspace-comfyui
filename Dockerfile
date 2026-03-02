# 最新のCUDA環境を使用（前方互換性を活用）
FROM nvidia/cuda:13.1.1-cudnn-devel-ubuntu22.04

ENV LANG=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive

# 画像・動画処理に必要なシステムパッケージをインストール
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

# ComfyUIの要件と、★超重要：BAN回避のための安全な中継パーツを追加インストール
RUN pip install --no-cache-dir -r requirements.txt jupyterlab jupyter-server-proxy

# Paperspace(8888)とComfyUI(8188)、TensorBoard(6006)のポートを開放
EXPOSE 8888 8188 6006

# 起動時のデフォルトの場所（ターミナルを開いた時の初期位置）を設定
WORKDIR /notebooks
