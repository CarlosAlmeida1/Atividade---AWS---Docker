<h1 align="center">Documentação</h1>

## 📝 Sobre o projeto

<p align="center">
  <img src="image/projeto-aws.png" alt="Fluxo do Projeto">
</p>

Este projeto é desenvolvido com o intuito de criar uma infraestrutura na AWS utilizando uma VPC, Subnets, Security Groups, EC2, RDS, Load Balancer, EFS, Bastion Host e Auto Scaling Group.

---

## Passo a passo para execução do projeto

### Pré-requisitos

- [Git](https://git-scm.com)
- [Conta na AWS](https://aws.amazon.com/pt/)
- [VSCode](https://code.visualstudio.com/) ou qualquer editor de texto de sua preferência

---

<h1 align="center">Iniciando Implantação do Laboratório</h1>

### ☁ Criando a infraestrutura na AWS

#### 1. Primeiro passo é iniciar a criação da VPC

<p align="center">
  <img src="image/vpc-1.png" alt="Criação da VPC">
</p>

Na imagem acima, é possível visualizar a criação de uma VPC.

Configurações: (Você pode colocar a configuração que desejar, abaixo está a configuração que foi utilizada nesse laboratório)

- Nome: `wordpress-vpc`
- CIDR Block: `10.0.0.0/16`
- IPv4 CIDR Block: `No IPv4 CIDR Block`
- Tenancy: `Default`
- Número de AZs: `2` (us-east-1a, us-east-1b)
- Número de subnets públicas: `2`
- Número de subnets privadas: `2`
- NAT Gateway: `none`
- VPC Endpoints: `S3`

<p align="center">
  <img src="image/vpc-2.png" alt="VPC Criada">
</p>

Na imagem acima, a VPC foi criada com sucesso.

---

#### 2. Criando Security Groups

<p align="center">
  <img src="image/sg-1.png" alt="Criação do Security Group">
</p>

Na imagem acima, é possível visualizar a criação de um Security Group.

Configurações:

O primeiro SG será privado:

- Nome: `wordpress-privado-sg`
- Descrição: `Security Group para instâncias privadas`
- Regras de entrada:
  - Type: `SSH`
  - Protocol: `TCP`
  - Port Range: `22`
  - Source: `0.0.0.0/0`
  - Type: `HTTP`
  - Protocol: `TCP`
  - Port Range: `80`
  - Source: `security group publico`
  - Type: `MySQL/Aurora`
  - Protocol: `TCP`
  - Port Range: `3306`
  - Source: `0.0.0.0/0`
  - Type: `HTTPS`
  - Protocol: `TCP`
  - Port Range: `443`
  - Source: `security group publico`

O segundo SG será público:

- Nome: `wordpress-publico-sg`
- Descrição: `Security Group para instâncias públicas`
- Regras de entrada:
  - Type: `SSH`
  - Protocol: `TCP`
  - Port Range: `22`
  - Source: `Anywhere IPv4`
  - Type: `HTTP`
  - Protocol: `TCP`
  - Port Range: `80`
  - Source: `0.0.0.0/0`

### User Data

```shell
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


```

---

#### 3. Criando RDS

Agora com todos os passos anteriores realizados, vamos criar o RDS, que será o banco de dados utilizado pelo Wordpress.

<p align="center">
  <img src="image/rds-1.png" alt="Criação do RDS">
</p>

Na imagem acima, é possível visualizar a criação de um RDS.

Selecionar o banco de dados MySQL.

Configurações:

- Engine options: `MySQL`
- Version: `MySQL 8.0.25`
- Templates: `Free tier`
- Settings:
  - DB instance identifier: `wordpress-db`
  - Master username: `admin`
  - Master password: `exemplosenha`
- DB instance size: `db.t2.micro`
- Storage: `20 GB`
- Connectivity:
  - VPC: `wordpress-vpc`
  - Subnet group: `wordpress-private-subnet-group`
  - Publicly accessible: `No`
  - VPC security group: `wordpress-sg`
- Additional configuration:
  - Initial database name: `wordpress`
- Desabilitando checks para evitar custo adicional.

Após a criação, é possível visualizar o endpoint do banco de dados.

Esse endpoint será utilizado para configurar o Wordpress.

No `docker-compose.yml`, é necessário alterar o endpoint, o nome do banco de dados, usuário e senha.

Acessando a EC2 e criando um banco chamado `wordpress` e alterando dentro do docker compose.

---

#### 4. Criando NAT Gateway

<p align="center">
  <img src="image/nat-gateway.png" alt="Criação do NAT Gateway">
</p>

Para a instância privada acessar a internet, é necessário criar um NAT Gateway.

Configurações: (Esse NAT Gateway será associado na subnet privada conforme o nome abaixo do laboratório)

- Nome: `wordpress-nat-gateway`
- Subnet: `wordpress-public-subnet-a`
- Elastic IP: `Create new EIP`

Após a criação, é necessário configurar a rota na tabela de rotas da VPC.

Coloque o NAT Gateway como destino e a Internet Gateway como alvo na tabela de rotas da subnet privada

<p align="center">
  <img src="image/nat-gateway-1.png" alt="Configuração do NAT Gateway">
</p>

Após a configuração, é possível acessar a instância privada e instalar o Docker e o Docker Compose.

---

#### 5. Criando EFS

<p align="center">
  <img src="image/efs-1.png" alt="Criação do EFS">
</p>

Clicando em `Create file system`, é possível visualizar a criação de um EFS.

Dê um nome ao EFS e selecione a VPC criada no passo 1 `wordpress-vpc`.

<p align="center">
  <img src="image/efs-2.png" alt="Criação do EFS">
</p>

Na imagem acima, é possível visualizar a criação de um EFS.

---

#### 6. Criando EC2 e Bastion Host

<p align="center">
  <img src="image/ec2-1.png" alt="Criação da EC2">
</p>

Na imagem acima, é possível visualizar a criação de uma EC2.

A primeira EC2 será o Bastion Host.

Configurações:

- AMI: `Amazon Linux 2023`
- Instance type: `t2.micro`
- Network: `wordpress-vpc`
- Subnet: `wordpress-public-subnet-a`
- Auto-assign Public IP: `Enable`
- Security Group: `wordpress-publico-sg`
- Key pair: `wordpress-key-pair`
- user data (Opcional), desejado apenas nas máquinas privadas (passo abaixo).

Você pode acessar a sua bastion host através do console AWS ou através da chave .pem do Bastion Host. (`wordpress-key-pair`)

<p align="center">
  <img src="image/bastion-host1.png" alt="Criação do Bastion Host">
</p>

A segunda EC2 será a instância privada.

Configurações:

- AMI: `Amazon Linux 2023`
- Instance type: `t2.micro`
- Network: `wordpress-vpc`
- Subnet: `wordpress-private1-subnet-a`
- Auto-assign Public IP: `Disable`
- Security Group: `wordpress-privado-sg`
- Key pair: `wordpress-key-pair`
- user data

A terceira EC2 será a instância privada.

Configurações:

- AMI: `Amazon Linux 2023`
- Instance type: `t2.micro`
- Network: `wordpress-vpc`
- Subnet: `wordpress-private2-subnet-b`
- Auto-assign Public IP: `Disable`
- Security Group: `wordpress-privado-sg`
- Key pair: `wordpress-key-pair`
- user data

Após a criação, é necessário acessar a instância Bastion Host e configurar o acesso à instância privada.

Para acessar o Bastion Host é necessário colocar o sg-privado como rota de entrada de SSH como anywhere IPv4.

---

#### 7. Criando Load Balancer e Auto Scaling Group

<p align="center">
  <img src="image/auto-scaling-group.png" alt="Criação do Auto Scaling Group">
</p>

Configurações do Auto Scaling Group:

- Nome: `wordpress-asg`
- Launch configuration: `wordpress-launch-config`
- Min size: `1`
- Max size: `3`
- Desired capacity: `1`
- Health check type: `EC2`
- Health check grace period: `300`
- Target group: `wordpress-tg`
- Availability Zones: `us-east-1a`, `us-east-1b`

Com essas configurações, o auto scaling group será criado com sucesso.

---

Criação do Load Balancer para ter acesso ao Wordpress usando as instâncias privadas e disponibilizando o acesso via navegador.

<p align="center">
  <img src="image/load-balancer-1.png" alt="Criação do Load Balancer">
</p>

Na imagem acima, é possível visualizar a criação de um Load Balancer.

Configurações:

- Nome: `wordpress-lb`
- Scheme: `internet-facing`
- VPC: `wordpress-vpc`
- Availability Zones: `us-east-1a`, `us-east-1b` public subnet
- Listeners:
  - Protocol: `HTTP`
  - Port: `80`

Conforme explicado acima, o Load Balancer será criado com o protocolo HTTP e a porta 80.

<p align="center">
  <img src="image/load-balancer-2.png" alt="Configuração do Load Balancer">
</p>

Health checks:

- Protocol: `HTTP`
- Path: `/wp-admin/install.php`

O Load Balancer precisa estar vinculado com a instância EC2 para que o health check funcione, sem isso o Load Balancer não passará pelo health check.

<p align="center">
  <img src="image/load-balancer-3.png" alt="Load Balancer em serviço">
</p>

Load Balancer criado com sucesso e em serviço, passando pelo health check.

---

## Conclusão

<p align="center">
  <img src="image/acesso-lb.png" alt="Acesso ao Wordpress">
</p>

Acessando o Wordpress através do DNS do Load Balancer.

<p align="center">
  <img src="image/wordpress-logado.png" alt="Wordpress Logado">
</p>

Wordpress acessado com sucesso.

---

<h2 align="center">👨‍💻 Autoria</h2>

<p align="center">
  Este projeto foi desenvolvido por <a href="https://github.com/CarlosAlmeida1">Carlos Henrique</a>. Atribuído pela <a href="https://compass.uol/pt/home/">Compass.Uol</a> e orientado por Thiago Geremias de Oliveira.
</p>
