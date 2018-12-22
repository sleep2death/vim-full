FROM sleep2death/vim-neo:latest
# User config
ENV UID="1000" \
    UNAME="dev" \
    GID="1000" \
    GNAME="dev" \
    SHELL="/bin/zsh" \
    UHOME="/home/dev"
# ENV
ENV TERM=xterm-256color
# User
RUN apk --no-cache add sudo \
    zsh \
# Create HOME dir
    && mkdir -p "${UHOME}" \
    && mkdir -p "${UHOME}/.vim/bundle" \
    && mkdir -p "${UHOME}/workspace" \
# Create user
    && echo "${UNAME}:x:${UID}:${GID}:${UNAME},,,:${UHOME}:${SHELL}" \
    >> /etc/passwd \
    && echo "${UNAME}::17032:0:99999:7:::" \
    >> /etc/shadow \
# No password sudo
    && echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" \
    > "/etc/sudoers.d/${UNAME}" \
    && chmod 0440 "/etc/sudoers.d/${UNAME}" \
# Create group
    && echo "${GNAME}:x:${GID}:${UNAME}" \
    >> /etc/group

USER $UNAME

COPY vimrc $UHOME/.vimrc
RUN sudo chown -R "${UID}":"${GID}" "${UHOME}" \
    && git clone https://github.com/VundleVim/Vundle.vim.git $UHOME/.vim/bundle/Vundle.vim \
    && vim +PluginInstall +qall \
    && wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true \
    && rm -rf \
    $GOPATH/src/* \
    && cd $UHOME && find . | grep "\.git/" | xargs rm -rf \
