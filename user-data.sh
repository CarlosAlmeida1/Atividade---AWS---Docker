#!/bin/bash
 
sudo yum update -y
sudo yum install -y docker
 
sudo systemctl start docker
sudo systemctl enable docker
 
sudo usermod -aG docker ec2-user
newgrp docker
 
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
 
sudo chmod +x /usr/local/bin/docker-compose
 
sudo mkdir /app
 
cat <<EOF > /app/compose.yml
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
      WORDPRESS_DB_NAME: wordpressdb
    volumes:
      - /mnt/efs:/var/www/html
EOF

sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-0fe2222edcfa9a8ae.efs.us-east-1.amazonaws.com:/ efs
 
docker-compose -f /app/compose.yml up -d
 
