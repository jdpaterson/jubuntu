FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y \
    ansible \
    build-essential \
    curl \
    git \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libssl-dev \
    libsqlite3-dev \
    make \
    software-properties-common \
    wget \
    yarn \
    zlib1g-dev \
    zsh

# apt-add-repository --yes --update ppa:ansible/ansible

# zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
COPY ./setup/.zshrc /root/.zshrc

# vim
RUN git clone https://github.com/vim/vim.git; \
    cd vim/src; \
    make; \
    make install;

# rbenv, ruby, bundler, rails
COPY ./setup/rbenv_rails.sh /src/setup-scripts/
RUN chmod +x /src/setup-scripts/rbenv_rails.sh
RUN ["/bin/bash", "-c", "/src/setup-scripts/rbenv_rails.sh"]

# nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
RUN /bin/bash -c export NVM_DIR="/root/.nvm" \
    [ -s "/root/.nvm/nvm.sh" ] && \. "/root/.nvm/nvm.sh" \
    [ -s "/root/.nvm/bash_completion" ] && \. "/root/.nvm/bash_completion"
RUN /bin/bash -c 'source ~/.nvm/nvm.sh; \
    nvm install node;'

# yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Salesforce sfdx
RUN wget https://developer.salesforce.com/media/salesforce-cli/sfdx-linux-amd64.tar.xz
RUN mkdir sfdx
RUN tar xJf sfdx-linux-amd64.tar.xz -C sfdx --strip-components 1 && ./sfdx/install

WORKDIR /home

CMD ["zsh"]

# docker build -t jubuntu .
# docker run -it --name jubuntu -v /home/jerbear:/home -p 3000:3000 jubuntu
# docker exec -it jubuntu /usr/bin/zsh