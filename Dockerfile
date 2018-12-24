FROM sleep2death/vim-full:latest
# GO ENV
ENV GOROOT="/usr/lib/go"
ENV GOPATH="${UHOME}"/workspace/go
ENV GOBIN="${GOPATH}"/bin
ENV PATH="${PATH}":"${GOBIN}":"${GOROOT}"/bin

# vim-go plugin
COPY vimrc .vimrc

RUN sudo apk --no-cache add \
    musl-dev \
    go \
    && mkdir -p $GOPATH \
    && mkdir $GOPATH/src \
    $GOPATH/bin \
    $GOPATH/pkg \
# clone golang tools mirror
    && git clone --depth 1 https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go \
    && git clone --depth 1 https://github.com/golang/tools.git $GOPATH/src/golang.org/x/tools \
    && git clone --depth 1 https://github.com/stamblerre/gocode.git $GOPATH/src/github.com/stamblerre/gocode \
    && cd $GOPATH/src/golang.org/x/tools/cmd/goimports && go install \
    && cd $GOPATH/src/golang.org/x/tools/cmd/guru && go install \
    && cd $GOPATH/src/github.com/stamblerre/gocode && go install \
    && go get -u github.com/golang/dep/cmd/dep \
# clean
    && rm -rf \
    $GOPATH/src/* \
    $GOPATH/pkg/* \
    $.cache/* \
    && cd ~ && find . | grep "\.git/" | xargs rm -rf

