FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'Acquire::http::Pipeline-Depth "5";' >> /etc/apt/apt.conf.d/99parallel
RUN apt update && apt install -y \
    git \
    g++ \
    cmake \
    ninja-build \
    llvm-15-dev \
    zlib1g-dev \
    libglew-dev \
    flex \
    bison \
    libfl-dev \
    libboost-thread-dev \
    libboost-filesystem-dev \
    nvidia-cuda-toolkit-gcc \
    ca-certificates \
    libzstd-dev \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --recurse-submodules https://github.com/gpuocelot/gpuocelot.git /gpuocelot
WORKDIR /gpuocelot/ocelot
RUN mkdir build
WORKDIR /gpuocelot/ocelot/build
RUN cmake .. -Wno-dev -G Ninja -DOCELOT_BUILD_TOOLS=OFF && ninja && ninja install

COPY tinygrad.tar.gz /tinygrad/
WORKDIR /tinygrad
RUN tar -xzf tinygrad.tar.gz && rm tinygrad.tar.gz

RUN pip install -e '.[testing,cuda]' --extra-index-url https://download.pytorch.org/whl/cpu --extra-index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/Triton-Nightly/pypi/simple/
