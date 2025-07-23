#!/bin/bash

set -e

# Create a 4GB swapfile
SWAPFILE="/swapfile"
if [ ! -f "$SWAPFILE" ]; then
    sudo fallocate -l 4G $SWAPFILE
    sudo chmod 600 $SWAPFILE
    sudo mkswap $SWAPFILE
    sudo swapon $SWAPFILE
    echo "$SWAPFILE none swap sw 0 0" | sudo tee -a /etc/fstab
    echo "Swapfile created and enabled."
else
    echo "Swapfile already exists."
fi

#Set ulimit for max memory usage
ulimit -m 15000
echo "ulimit for max memory usage set to 15000."

# Set ulimit for open files
ulimit -n 4096
echo "ulimit for open files set to 4096."

# Set vm.swappiness to 80
sudo sysctl vm.swappiness=80
echo "vm.swappiness set to 80."

# Protect critical processes from OOM killer
echo -1000 | sudo tee /proc/$$/oom_score_adj

echo "Memory performance tweaks applied."
