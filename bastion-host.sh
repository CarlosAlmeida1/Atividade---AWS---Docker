BASTION_HOST=52.90.46.62
PRIVATE_EC2=10.0.9.23
USER="ec2-user"
PORT="22"
IDENTITY_FILE="~/.ssh/PB-Nov-2024.pem"

Host bastion-host
HostName 3.91.62.244
User ec2-user
Port 22
IdentityFile ~/.ssh/PB-Nov-2024.pem
IdentitiesOnly yes

Host private-ec2
HostName 10.0.130.201
User ec2-user
Port 22
IdentityFile ~/.ssh/PB-Nov-2024.pem
IdentitiesOnly yes
ProxyJump bastion-host  