# Use a imagem oficial do Ruby
FROM ruby:3.4.3

# Instale dependências do sistema
RUN apt-get update -qq && \
    apt-get install -y curl gnupg build-essential libpq-dev nodejs postgresql-client && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq && \
    apt-get install -y yarn

# Crie um diretório para o aplicativo
RUN mkdir /inss_discount
WORKDIR /inss_discount

# Copie o Gemfile e o Gemfile.lock para o contêiner
COPY Gemfile /inss_discount/Gemfile
COPY Gemfile.lock /inss_discount/Gemfile.lock

# Instale as gems
RUN bundle install

# Copie o restante do código do aplicativo para o contêiner
COPY . /inss_discount

# Compile os assets
RUN bin/rails assets:precompile

# Exponha a porta 3000
EXPOSE 3000

# Comando para rodar o servidor
CMD ["rails", "server", "-b", "0.0.0.0"]
