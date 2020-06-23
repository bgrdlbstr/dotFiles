FROM ubuntu:latest

RUN apt-get update && apt-get install -qq -y \
  vim git zsh tmux openssh-client bash curl less man silversearcher-ag sudo

# Create a user called 'david'
RUN useradd -ms /bin/zsh david
# Do everything from now in that users home directory
WORKDIR /home/david
ENV HOME /home/david

RUN curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | zsh || true

RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

RUN git clone https://github.com/sjl/badwolf.git
RUN cp -r badwolf/contrib ~/.vim
RUN cp -r badwolf/colors ~/.vim
RUN rm -r badwolf

RUN git clone https://github.com/bgrdlbstr/dotFiles.git
RUN cp dotFiles/zshrc .zshrc
RUN cp dotFiles/p10k.zsh .p10k.zsh
RUN cp dotFiles/vimrc .vimrc
RUN cp dotFiles/tmux.conf .tmux.conf
RUN cp dotFiles/entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh
RUN rm -r dotFiles

RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN vim -es -u .vimrc -i NONE -c "PlugInstall" -c "qa"

RUN git clone https://github.com/tmux-plugins/tpm .tmux/plugins/tpm
RUN .tmux/plugins/tpm/bin/install_plugins

# Set working directory to /workspace
WORKDIR /workspace
# Default entrypoint, can be overridden
CMD ["/bin/entrypoint.sh"]

