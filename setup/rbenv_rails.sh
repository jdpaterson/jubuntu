git clone https://github.com/rbenv/rbenv.git /root/.rbenv
git clone https://github.com/rbenv/ruby-build.git /root/.rbenv/plugins/ruby-build
echo 'export PATH="/root/.rbenv/bin:$PATH"' >> /root/.zshrc
echo 'eval "$(/root/.rbenv/bin/rbenv init -)"' >> /root/.zshrc
source /root/.zshrc
rbenv install 2.6.6
rbenv global 2.6.6
gem install bundler
gem install rails
