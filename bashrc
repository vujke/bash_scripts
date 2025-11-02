# Aliases
alias sd="sudo shutdown -h now"
alias rb="sudo reboot"
alias yi="sudo yum install"
alias yu="sudo yum update"
alias ping="ping -c4"
alias pg="ping -c4 google.com" 

# Functions
function pc() {
ping -c4 192.168.1.$1
}

function sr() {
sudo systemctl restart $1
}
