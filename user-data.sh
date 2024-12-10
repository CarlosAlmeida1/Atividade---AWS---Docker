#!/bin/bash
dnf update -y

dnf install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# arquivo que eu vou usar para subir o container
cat <<EOF > /home/ec2-user/docker-compose.yml
version: '3.1'

services:
  wordpress:
    image: wordpress
    restart: always
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: "127.0.0.1"
      WORDPRESS_DB_USER: "exampleuser"
      WORDPRESS_DB_PASSWORD: "examplepass"
      WORDPRESS_DB_NAME: "exampledb"
    volumes:
      - wordpress:/var/www/html

volumes:
  wordpress:
EOF

# subir o container
cd /home/ec2-user/wordpress
docker-compose up -d
