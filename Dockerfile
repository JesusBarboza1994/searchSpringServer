# Utiliza una imagen base de Ruby
FROM ruby:3.1.3

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Instala las dependencias
RUN apt-get update && \
    apt-get install -y freetds-dev

# Copia el Gemfile y Gemfile.lock al contenedor
COPY Gemfile Gemfile.lock ./

# Instala las gemas
RUN bundle install

# Copia el resto de tu aplicación Rails
COPY . .

# Especifica el comando para iniciar tu aplicación Rails
CMD ["rails", "server", "-b", "0.0.0.0"]
