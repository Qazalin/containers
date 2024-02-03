FROM catthehacker/ubuntu:act-latest

RUN apt update && apt install -y \
    git \
    curl \
    zsh \
    stow \
    tmux \
    fzf \
    ripgrep \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# setup zsh
CMD ["zsh"]
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# (almost) bleeding edge neovim
RUN apt update && apt install -y ninja-build gettext cmake unzip && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/neovim/neovim.git && cd neovim && git checkout d772f697a281ce9c58bf933997b87c7f27428a60 && make CMAKE_BUILD_TYPE=Release && make install

# fnm (for lsp)
RUN curl -fsSL https://fnm.vercel.app/install | bash

# .dotfiles
RUN git clone -b master https://github.com/Qazalin/.dotfiles.git /root/code/tools/.dotfiles
WORKDIR /root/code/tools/.dotfiles
RUN rm -rf /root/.zshrc && stow -t ~ nvim tmux zsh

RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# rocm
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'Acquire::http::Pipeline-Depth "5";' > /etc/apt/apt.conf.d/99parallel \
    && apt-get update && apt-get install -y --no-install-recommends wget gnupg \
    && wget https://repo.radeon.com/rocm/rocm.gpg.key -O - | gpg --dearmor > /etc/apt/keyrings/rocm.gpg \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/debian jammy main" > /etc/apt/sources.list.d/rocm.list \
    && echo -e 'Package: *\nPin: release o=repo.radeon.com\nPin-Priority: 600' > /etc/apt/preferences.d/rocm-pin-600 \
    && apt-get update \
    && apt-get install --no-install-recommends --allow-unauthenticated -y rocm-hip-libraries hip-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# tinygrad
RUN git clone --depth 1 https://github.com/Qazalin/tinygrad.git /root/code/tinygrad/tinygrad
WORKDIR /root/code/tinygrad/tinygrad
RUN git remote remove origin && git remote add origin https://github.com/Qazalin/tinygrad.git && git remote add upstream https://github.com/tinygrad/tinygrad.git
RUN git fetch --depth 1 origin f8c3d5ca94b1cbb10ba36c95022785b63e92915b && git checkout f8c3d5ca94b1cbb10ba36c95022785b63e92915b
RUN pip install -e .
EXPOSE 80
CMD ["python", "server.py"]

# making rocm work
RUN sudo apt update && sudo apt-get -y install prelink
RUN sudo execstack -c /opt/rocm/lib/libamdhip64.so*

# git config
RUN git config --global --add user.name qazal && git config --global --add user.email qazal.software@gmail.com && git config --global core.editor "nvim"
