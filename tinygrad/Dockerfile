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
    vim \
    && rm -rf /var/lib/apt/lists/*

# setup zsh
CMD ["zsh"]

# .dotfiles
RUN git clone -b master https://github.com/Qazalin/.dotfiles.git /root/code/tools/.dotfiles
WORKDIR /root/code/tools/.dotfiles
RUN rm -rf /root/.zshrc && stow -t ~ tmux zsh

# tinygrad
RUN git clone https://github.com/tinygrad/tinygrad.git /root/code/tinygrad/tinygrad
WORKDIR /root/code/tinygrad/tinygrad
RUN git remote remove origin && git remote add origin https://github.com/Qazalin/tinygrad.git && git remote add upstream https://github.com/tinygrad/tinygrad.git

# remu
WORKDIR /root/code/
RUN git clone https://github.com/Qazalin/remu.git
RUN curl https://gist.github.com/Qazalin/9df9d3edf19a713f4a092e44911c516b > /tmp/k && chmod +x /tmp/k
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN cd remu && cargo build
