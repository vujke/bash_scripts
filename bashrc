# Aliases
alias sd="sudo shutdown -h now"
alias rb="sudo reboot"
alias di="sudo dnf install"
alias diy="sudo dnf install -y"
alias du="sudo dng update"
alias ping="ping -c4"
alias pg="ping -c4 google.com" 

# Functions
function pc() {
ping -c4 192.168.1.$1
}

function sr() {
sudo systemctl restart $1
}

function ss() {
systemctl status $1
}

function sx() {
sudo systemctl $1 $2
}
