#!/bin/bash

LOG="/var/log/secure"
EMAIL="@gmail.com"
HOSTNAME=$(hostname)
SUBJECT="Failed SSH Login Attempts on $HOSTNAME"
DISTRONAME=$(awk -F 'NAME=' '/^NAME=/{gsub(/"/,"",$2); print $2}' /etc/os-release)
DISTROVER=$(awk -F 'VERSION_ID=' '/^VERSION_ID=/{gsub(/"/,"",$2); print $2}' /etc/os-release)
KERNEL_VER=$(uname -r)
ISA=$(uname -m)
TIME=$(date)

REPORT=$(sudo awk '
BEGIN {
    printf "%-20s %-15s %-15s\n", "DATE", "IP ADDRESS", "USERNAME"
    printf "%-20s %-15s %-15s\n", "--------------------", "---------------", "---------------"
}

/Failed/ {
    date = $1 " " $2 " " $3
    ip = ""
    user = ""

    for (i=1; i<=NF; i++) {
        if ($i == "for") user = $(i+1)
        if ($i == "from") ip = $(i+1)
    }

    if (ip ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/) {
        count[ip]++
        printf("%-20s %-15s %-15s\n", date, ip, user)
    }
}

END {
    print "\n=== Failed Attempts per IP ==="
    for (ip in count)
        printf "%-15s => %d attempts\n", ip, count[ip]
}' "$LOG")

MESSAGE=$(printf "Unattended login attempts detected on:
%s v%s; %s@%s @ %s\n
Sent on %s

%s\n" \
"$DISTRONAME" "$DISTROVER" "$KERNEL_VER" "$ISA" "$HOSTNAME" "$TIME" "$REPORT")

# Send email only if report is not empty
if [[ -n "$REPORT" ]]; then
    echo "$MESSAGE" | mailx -r "alert@$HOSTNAME" -s "$SUBJECT" "$EMAIL"
fi
