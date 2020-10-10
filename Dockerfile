FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive
ARG TIMEZONE=Canada/Pacific
ARG USER_ID=1000
ARG GROUP_ID=1001
RUN apt update && apt install -y \
    ansible \
    build-essential \
    curl \
    git \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libssl-dev \
    libffi-dev \
    libsqlite3-dev \
    make \
    python3.8 \
    python3-pip \
    python3-dev \
    python3-venv \
    software-properties-common \
    sudo \
    unzip \
    vim \
    wget \
    zlib1g-dev \
    zsh

# Postgres
RUN echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt update \
    && apt install -y postgresql libpq-dev

# Prep for yarn install
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# apt-add-repository --yes --update ppa:ansible/ansible
RUN echo $TIMEZONE > /etc/timezone

RUN groupadd -r -g $GROUP_ID jubuntu
RUN useradd -rm -d /home/jubuntu -s /bin/bash -g root -G jubuntu -u $USER_ID jubuntu
RUN usermod -aG sudo jubuntu
RUN echo "jubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY ./setup/.bash_functions /home/jubuntu/.bash_functions/
RUN chmod -R g+rwx /home/jubuntu/.bash_functions

# Salesforce sfdx
RUN wget https://developer.salesforce.com/media/salesforce-cli/sfdx-linux-amd64.tar.xz
RUN mkdir sfdx
RUN tar xJf sfdx-linux-amd64.tar.xz -C sfdx --strip-components 1 && ./sfdx/install

COPY ./setup/rbenv_rails.sh /home/jubuntu/setup/
COPY ./setup/Gemfile /home/jubuntu/setup/sample-rails/
RUN chmod -R g+rwx /home/jubuntu/setup

USER jubuntu

RUN mkdir /home/jubuntu/.ssh

# rbenv, ruby, rails, global gems
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN ["/bin/bash", "-c", "/home/jubuntu/setup/rbenv_rails.sh"]

USER root
COPY ./setup/nvm.sh /home/jubuntu/setup/
RUN chmod -R g+rwx /home/jubuntu/setup
USER jubuntu

# nvm, node, yarn, global packages
ENV XDG_CONFIG_HOME /home/jubuntu
RUN ["zsh", "-c", "/home/jubuntu/setup/nvm.sh"]

# install go
USER root
RUN curl -O https://dl.google.com/go/go1.15.2.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.15.2.linux-amd64.tar.gz

# install ngrok
RUN curl https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -o ngrok.zip \
    && unzip ngrok.zip

COPY ./setup/.zshrc /home/jubuntu/.zshrc
RUN chmod g+rwx /home/jubuntu/.zshrc
USER jubuntu
WORKDIR /home/jubuntu/workdir

CMD ["zsh"]