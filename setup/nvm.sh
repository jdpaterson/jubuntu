curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
export NVM_DIR="/root/.nvm" [ -s "/root/.nvm/nvm.sh" ] && \. "/root/.nvm/nvm.sh" [ -s "/root/.nvm/bash_completion" ] && \. "/root/.nvm/bash_completion"
source ~/.nvm/nvm.sh
nvm install node
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - 
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt update && apt install -y yarn
cd /src/setup-scripts/sample-rails 
yarn global add @rails/actioncable @rails/activestorage @rails/ujs @rails/webpacker turbolinks webpack-dev-server