FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
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
# TODO remove once done w dev
#ARG CACHEBUST=1
RUN git clone -b linux https://github.com/Qazalin/.dotfiles.git /root/.dotfiles
RUN rm -rf root/.zshrc && cd root/.dotfiles && stow nvim tmux zsh

RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

RUN zsh -c "curl -fsSL https://fnm.vercel.app/install | bash && source ~/.zshrc && fnm install 16"
# TODO make this automatic
RUN echo 'vim ~/.dotfiles/nvim/.config/nvim/lua/qazal/packer.lua -c "source %" -c "PackerSync" -c "qa"'
