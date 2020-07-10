FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive
ARG TIMEZONE=Canada/Pacific
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
RUN echo $TIMEZONE > /etc/timezone

# zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
COPY ./setup/.zshrc /root/.zshrc

# vim
RUN git clone https://github.com/vim/vim.git; \
    cd vim/src; \
    make; \
    make install;

# Postgres
RUN echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt update \
    && apt install -y postgresql libpq-dev

# rbenv, ruby, bundler, rails, basic gems
COPY ./setup/rbenv_rails.sh /src/setup-scripts/
COPY ./setup/Gemfile /src/setup-scripts/sample-rails/Gemfile
RUN chmod +x /src/setup-scripts/rbenv_rails.sh
RUN ["/bin/bash", "-c", "/src/setup-scripts/rbenv_rails.sh"]

# nvm, yarn, basic global libraries
COPY ./setup/nvm.sh /src/setup-scripts/
RUN chmod +x /src/setup-scripts/nvm.sh
RUN ["/bin/bash", "-c", "/src/setup-scripts/nvm.sh"]

# Salesforce sfdx
RUN wget https://developer.salesforce.com/media/salesforce-cli/sfdx-linux-amd64.tar.xz
RUN mkdir sfdx
RUN tar xJf sfdx-linux-amd64.tar.xz -C sfdx --strip-components 1 && ./sfdx/install

WORKDIR /home

CMD ["zsh"]