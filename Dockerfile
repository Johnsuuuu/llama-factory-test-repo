FROM nvidia/cuda:12.1.0-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV NVIDIA_VISIBLE_DEVICES=
ENV TORCH_CUDA_ARCH_LIST="7.5;8.0;8.6;8.9"

RUN sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list \
&& apt-get update \
&& apt-get install -y software-properties-common curl vim build-essential \
&& add-apt-repository -y ppa:deadsnakes/ppa \
&& apt-get update \
&& apt-get install -y python3.10 python3.10-dev \
&& rm -rf /usr/bin/python3 && ln -s /usr/bin/python3.10 /usr/bin/python3 \
&& apt-get autoclean && rm -rf /var/lib/apt/lists/* \
&& curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py \
&& python3 get-pip.py \
&& rm get-pip.py \
&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& echo "Asia/Shanghai" > /etc/timezone

WORKDIR /app

COPY requirements.txt /app/

RUN pip3 install --upgrade pip \
&& pip3 install --upgrade setuptools \
&& pip3 install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

COPY . /app

RUN pip3 install --no-cache-dir -e .[metrics,qwen] -i https://pypi.tuna.tsinghua.edu.cn/simple \
&& cd AutoGPTQ && pip3 install . -i https://pypi.tuna.tsinghua.edu.cn/simple

RUN chmod +x /app/server.sh

ENV API_PORT=8000

CMD ["./server.sh"]
