curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n
bash n lts
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - 
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt update && apt install -y yarn
yarn global add @rails/actioncable @rails/activestorage @rails/ujs @rails/webpacker turbolinks webpack-dev-server
npm install -g n gatsby-cli