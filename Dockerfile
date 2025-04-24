# Use a imagem oficial do Ruby
FROM ruby:3.4.3

# Instale dependências do sistema
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs && apt-get install -y postgresql-client

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

# Exponha a porta 3000
EXPOSE 3000

# Comando para rodar o servidor
CMD ["rails", "server", "-b", "0.0.0.0"]