# Aliases
alias sd="sudo shutdown -h now"
alias rb="sudo reboot"
alias yi="sudo yum install"
alias yu="sudo yum update"

# Functions
function ping() {
ping -c4 192.168.1.$1
}
