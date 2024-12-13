#!/bin/bash

sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user

sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo dnf install mariadb105 -y 


cat <<EOF > docker-compose.yml
version: '3.1'

services:
  wordpress:
    image: wordpress
    restart: always
    ports:
      - 80:80
    environment:
      WORDPRESS_DB_HOST: wordpress-db.czwaygssin91.us-east-1.rds.amazonaws.com
      WORDPRESS_DB_USER: administrador
      WORDPRESS_DB_PASSWORD: 12072006
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - wordpress:/var/www/html

volumes:
  wordpress:
EOF


docker-compose up -d

echo 