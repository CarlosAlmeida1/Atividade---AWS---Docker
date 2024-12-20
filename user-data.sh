#!/bin/bash

# Atualiza o sistema e instala o Docker
sudo yum update -y
sudo yum install -y docker

# Inicia e habilita o serviço Docker
sudo systemctl start docker
sudo systemctl enable docker

# Adiciona o usuário ec2-user ao grupo Docker
sudo usermod -aG docker ec2-user
newgrp docker

# Baixa e instala o Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo dnf install mariadb105 -y 

# Cria um diretório para o Docker Compose
sudo mkdir -p /docker-compose-project
cd /docker-compose-project

# Cria o arquivo docker-compose.yml
sudo cat <<EOF > docker-compose.yml
version: '3.1'

services:
  wordpress:
    image: wordpress
    restart: always
    ports:
      - 80:80
    environment:
      WORDPRESS_DB_HOST: wordpress-db.czwaygssin91.us-east-1.rds.amazonaws.com
      WORDPRESS_DB_USER: admin
      WORDPRESS_DB_PASSWORD: 12072006
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - wordpress:/var/www/html

volumes:
  wordpress:
EOF

# Reinicia o serviço Docker
sudo systemctl restart docker

# Executa o Docker Compose
sudo /usr/local/bin/docker-compose up -d