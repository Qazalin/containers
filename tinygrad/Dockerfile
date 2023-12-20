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
RUN git clone -b linux https://github.com/Qazalin/.dotfiles.git /root/code/tools/.dotfiles
WORKDIR /root/code/tools/.dotfiles
RUN rm -rf /root/.zshrc && stow -t ~ nvim tmux zsh

RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# tinygrad
RUN git clone https://github.com/tinygrad/tinygrad.git /root/code/tinygrad/tinygrad
WORKDIR /root/code/tinygrad/tinygrad
RUN git remote remove origin && git remote add origin https://github.com/Qazalin/tinygrad.git && git remote add upstream https://github.com/tinygrad/tinygrad.git
