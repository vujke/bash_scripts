#!/bin/bash

LOG="/var/log/secure"
EMAIL="@gmail.com"
HOSTNAME=$(hostname)
SUBJECT="Failed SSH Login Attempts on $HOSTNAME"
DISTRONAME=$(awk -F 'NAME=' '/^NAME=/{gsub(/"/,"",$2); print $2}' /etc/os-release)
DISTROVER=$(awk -F 'VERSION_ID=' '/^VERSION_ID=/{gsub(/"/,"",$2); print $2}' /etc/os-release)
KERNEL_VER=$(hostnamectl | awk '/Kernel:/ {print $3}')
ISA=$(hostnamectl | awk '/Architecture:/ {print $2}')
HOSTNAME=$(hostname)
TIME=$(date)

MESSAGE=$(sudo awk '
/Failed/ {
    date = $1 " " $2 " " $3
    user = ""
    ip = ""

    for (i=1; i<=NF; i++) {
        if ($i == "for") user = $(i+1)
        if ($i == "from") ip = $(i+1)
    }
    
    # Count only if IP is valid IPv4
    if (ip ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/) {
        count[ip]++
        printf("On %s from %s tried to login as %s.\n", date, ip, user)
    }
}

END {
    print "\n=== Failed Attempts per IP ==="
    for (ip in count)
        printf "%s => %d attempts\n", ip, count[ip]
}' "$LOG")


# Send email only if there are results
if [[ -n "$MESSAGE" ]]; then
    echo "$MESSAGE" | mailx -r "alert@$HOSTNAME" -s "$SUBJECT" "$EMAIL"
fi
