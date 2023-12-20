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
RUN git clone https://github.com/neovim/neovim.git && cd neovim && make CMAKE_BUILD_TYPE=Release && make install

# fnm (for lsp)
RUN curl -fsSL https://fnm.vercel.app/install | bash

# .dotfiles
RUN git clone -b master https://github.com/Qazalin/.dotfiles.git /root/code/tools/.dotfiles
WORKDIR /root/code/tools/.dotfiles
RUN rm -rf /root/.zshrc && stow -t ~ nvim tmux zsh

RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# tinygrad
RUN git clone https://github.com/tinygrad/tinygrad.git /root/code/tinygrad/tinygrad
WORKDIR /root/code/tinygrad/tinygrad
RUN git remote remove origin && git remote add origin https://github.com/Qazalin/tinygrad.git && git remote add upstream https://github.com/tinygrad/tinygrad.git

# git config
RUN git config --global --add user.name qazal && git config --global --add user.email qazal.software@gmail.com

# --- tiyngrad backends setup ---

# HIP
RUN echo 'Acquire::http::Pipeline-Depth "5";' > /etc/apt/apt.conf.d/99parallel && \
    wget https://repo.radeon.com/rocm/rocm.gpg.key -O - | gpg --dearmor > /etc/apt/keyrings/rocm.gpg && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/rocm.gpg] https://repo.radeon.com/rocm/apt/debian jammy main" > /etc/apt/sources.list.d/rocm.list && \
    echo -e 'Package: *\nPin: release o=repo.radeon.com\nPin-Priority: 600' > /etc/apt/preferences.d/rocm-pin-600 && \
    apt update && \
    apt install --no-install-recommends --allow-unauthenticated -y rocm-hip-libraries hip-dev
