<h1 align="center">Documentação</h1>

## 📝 Sobre o projeto

<p align="center">
  <img src="image/projeto-aws.png" alt="imagem de fluxo do projeto">
</p>

<p align="center">
  Este projeto é desenvolvido com o intuito de criar uma infraestrutura na AWS utilizando uma VPC, Subnets, Security Groups, EC2, RDS e um Load Balancer.
</p>

## Passo a passo para execução do projeto

### Pré-requisitos

Antes de começar, é necessário ter instalado em sua máquina as seguintes ferramentas:

- [Git](https://git-scm.com)
- [Conta na AWS](https://aws.amazon.com/pt/)
- [Conta no Docker Hub](https://hub.docker.com/)

Além disto, é bom ter um editor para trabalhar com o código, como [VSCode](https://code.visualstudio.com/).

### ☁ Criando a infraestrutura na AWS

| Etapa | Descrição |
|-------|-----------|
| **1. Criando VPC** | - Acesse o console da AWS e vá até o serviço VPC<br>- Clique em "Your VPCs" e depois em "Create VPC"<br>- Preencha os campos Name tag e IPv4 CIDR block<br>- Clique em "Create VPC" |
| **2. Criando Subnets** | - Crie duas subnets, uma pública e outra privada<br>- A subnet pública deve ter a opção Auto-assign Public IPv4 Address habilitada<br>- A subnet privada deve ter a opção Auto-assign Public IPv4 Address desabilitada |
| **3. Criando Internet Gateway** | - Vá até o serviço VPC e clique em "Internet Gateways"<br>- Clique em "Create internet gateway"<br>- Preencha o campo Name tag e clique em "Create internet gateway"<br>- Selecione o internet gateway criado e clique em "Attach to VPC"<br>- Selecione a VPC criada e clique em "Attach internet gateway"<br>- Vá até a aba "Route Tables" e selecione a route table associada à VPC<br>- Clique em "Edit routes" e adicione uma rota com Destination<br>- Clique em "Add route" e adicione uma rota com Destination |
| **4. Criando Security Groups** | - Crie um security group para o Load Balancer<br>- Crie um security group para a instância EC2<br>- Crie um security group para o banco de dados RDS |
| **5. Criando instância EC2** | - Crie uma instância EC2 com a subnet pública e o security group da instância EC2<br>- A instância deve ter uma chave para acesso SSH<br>- Amazon Linux 2023<br>- t2.micro |
| **6. Criando banco de dados RDS** | - Crie um banco de dados RDS com a subnet privada e o security group do banco de dados RDS<br>- Selecione o banco de dados MySQL<br>- Preencha os campos DB instance identifier, Master username e Master password<br>- Clique em "Create database"<br>- db.t3.micro<br>- Multi-AZ deployment: Desabilitado<br>- Public access: Não<br>- Associar a uma VPC: Selecione a VPC criada<br>- Subnet group: Selecione a subnet privada<br>- Security group: Selecione o security group do banco de dados RDS<br>- Vincular ao EC2 |
| **7. Criando Load Balancer** | - Crie um Load Balancer com a subnet pública e o security group do Load Balancer<br>- Selecione o Load Balancer do tipo Classic Load Balancer<br>- Preencha os campos Name, Listener configuration e Availability Zones<br>- Selecione o security group do Load Balancer<br>- Selecione a subnet pública<br>- Selecione a instância EC2 |
| **8. Configurando EFS** | - Criando... |
| **9. Acessando a aplicação** | - Criando... |

### 📂 Estrutura do Projeto

```plaintext
.
├── image/
│   └── projeto-aws.png
├── [README.md]
└── [user-data.sh]
```