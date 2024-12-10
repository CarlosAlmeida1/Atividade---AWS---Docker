<h1 align="center">Documentação<h1>

## 📝 Sobre o projeto

<img src="image/projeto-aws.png" align="center" alt="imagem de fluxo do projeto">

<p>Este projeto é desenvolvido com o intuito de criar uma infraestrutura na AWS utilizando uma VPC, Subnets, Security Groups, EC2, RDS e um Load Balancer.
</p>

## Passo a passo para execução do projeto

### Pré-requisitos

Antes de começar, é necessário ter instalado em sua máquina as seguintes ferramentas:

- [Git](https://git-scm.com)
- [Conta na AWS](https://aws.amazon.com/pt/)
- [Conta no Docker Hub](https://hub.docker.com/)

Além disto é bom ter um editor para trabalhar com o código como [VSCode](https://code.visualstudio.com/)

### ☁ Criando a infraestrutura na AWS

1. Criando VPC

- Acesse o console da AWS e vá até o serviço VPC
- Clique em "Your VPCs" e depois em "Create VPC"
- Preencha os campos Name tag e IPv4 CIDR block
- Clique em "Create VPC"

2. Criando Subnets

- Crie duas subnets, uma pública e outra privada
- A subnet pública deve ter a opção Auto-assign Public IPv4 Address habilitada
- A subnet privada deve ter a opção Auto-assign Public IPv4 Address desabilitada

3. Criando Internet Gateway

- Vá até o serviço VPC e clique em "Internet Gateways"
- Clique em "Create internet gateway"
- Preencha o campo Name tag e clique em "Create internet gateway"
- Selecione o internet gateway criado e clique em "Attach to VPC"
- Selecione a VPC criada e clique em "Attach internet gateway"
- Vá até a aba "Route Tables" e selecione a route table associada a VPC
- Clique em "Edit routes" e adicione uma rota com Destination
- Clique em "Add route" e adicione uma rota com Destination

