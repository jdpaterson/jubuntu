git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
cd ~/.rbenv && src/configure && make -C src
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(~/.rbenv/bin/rbenv init -)"
rbenv install 2.6.6
rbenv global 2.6.6
gem install bundler
gem install rails
cd ~/setup/sample-rails
bundle