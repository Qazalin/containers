FROM catthehacker/ubuntu:act-latest

RUN apt update && apt install -y \
    git \
    curl \
    zsh \
    stow \
    tmux \
    fzf \
    ripgrep \
    && rm -rf /var/lib/apt/lists/*

# setup zsh
CMD ["zsh"]
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# (almost) bleeding edge neovim
RUN apt update && apt install -y ninja-build gettext cmake unzip && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/neovim/neovim.git && cd neovim && make CMAKE_BUILD_TYPE=Release && make install

# .dotfiles
RUN git clone -b linux https://github.com/Qazalin/.dotfiles.git /root/.dotfiles
RUN rm -rf /root/.zshrc && cd /root/.dotfiles && stow nvim tmux zsh

RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# CUDA
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

RUN git clone https://github.com/tinygrad/tinygrad.git /root/tinygrad
WORKDIR /root/tinygrad
RUN pip install -e '.[testing]' && pip install -e '.[cuda]' && pip install -e .
RUN git remote remove origin && git remote add origin https://github.com/Qazalin/tinygrad.git && git remote add upstream https://github.com/tinygrad/tinygrad.git
