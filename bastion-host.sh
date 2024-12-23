BASTION_HOST="44.203.92.241"
PRIVATE_EC2="10.0.155.229"
USER="ec2-user"
PORT="22"
IDENTITY_FILE="~/.ssh/PB-Nov-2024.pem"

Host bastion-host
    HostName $BASTION_HOST
    User $USER
    Port $PORT
    IdentityFile $IDENTITY_FILE
    IdentitiesOnly yes

Host private-ec2
    HostName $PRIVATE_EC2
    User $USER
    Port $PORT
    IdentityFile $IDENTITY_FILE
    IdentitiesOnly yes
    ProxyJump bastion-host