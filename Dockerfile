FROM ubuntu
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \    
    build-essential \
    curl \
    git \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \    
    libssl-dev \    
    libsqlite3-dev \
    make \
    wget \
    zlib1g-dev \
    zsh
# Zsh setup
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
COPY ./setup/.zshrc /root/.zshrc

# Vim setup
RUN git clone https://github.com/vim/vim.git; \
    cd vim/src; \
    make; \
    make install;


# Install rbenv, ruby, bundler, rails
COPY ./setup/rbenv_rails.sh /src/setup-scripts/
RUN chmod +x /src/setup-scripts/rbenv_rails.sh
RUN ["/bin/bash", "-c", "/src/setup-scripts/rbenv_rails.sh"]

# Old code that was moved over to script
# RUN git clone https://github.com/rbenv/rbenv.git /root/.rbenv
# RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
# RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
# RUN echo 'eval "$(rbenv init -)"' >> ~/.zshrc
# RUN /bin/bash -c 'source ~/.zshrc; \
#     rbenv install 2.6.6; \
#     rbenv global 2.6.6; \
#     gem install bundler; \
#     gem install rails;'

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
RUN /bin/bash -c export NVM_DIR="/root/.nvm" \
    [ -s "/root/.nvm/nvm.sh" ] && \. "/root/.nvm/nvm.sh" \
    [ -s "/root/.nvm/bash_completion" ] && \. "/root/.nvm/bash_completion" 

RUN /bin/bash -c 'source ~/.nvm/nvm.sh; \
    nvm install node;'
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt install yarn -y
RUN ["zsh", "rails new test_app"]
WORKDIR /home
EXPOSE 3000
CMD ["zsh"]

# docker build -t jubuntu .
# docker run -it --name jubuntu -v /home/jerbear/projects:/home/projects -p 3000:3000 jubuntu
# Inside Container: rails s --binding 0.0.0.0
# docker exec -it jubuntu /usr/bin/zsh