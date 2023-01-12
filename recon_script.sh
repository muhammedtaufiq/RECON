#!/bin/bash

# prompt for input website URL or IP address
echo "Enter website URL or IP address:"
read input

# perform dig command with axfr option
sudo dig axfr $input

# perform host command
sudo host $input

echo "Select nmap options:"
echo "1) -sT (TCP connect scan)"
echo "2) -sS (TCP SYN scan)"
echo "3) -sU (UDP scan)"
echo "4) -sN (TCP NULL scan)"
echo "5) -sF (TCP FIN scan)"
echo "6) -sX (TCP Xmas scan)"
echo "7) -sA (TCP ACK scan)"
echo "8) -sW (TCP Window scan)"
echo "9) -sM (TCP Maimon scan)"
echo "10) -sI (Idle scan)"
echo "11) Done (when you have selected all the options)"

options=""
while true; do
    read option
    if [ $option -eq 11 ]; then
        break
    fi
    options="$options $(sed -n "${option}p" <<< "1) -sT (TCP connect scan)
2) -sS (TCP SYN scan)
3) -sU (UDP scan)
4) -sN (TCP NULL scan)
5) -sF (TCP FIN scan)
6) -sX (TCP Xmas scan)
7) -sA (TCP ACK scan)
8) -sW (TCP Window scan)
9) -sM (TCP Maimon scan)
10) -sI (Idle scan)")"
done

sudo nmap $options $input &
nmap_pid=$!

# Wait for nmap to finish
while kill -0 "$nmap_pid" &>/dev/null; do
    sleep 1
done
