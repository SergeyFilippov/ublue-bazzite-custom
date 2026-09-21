# Install and start Netbird service
setup-netbird:
    #!/usr/bin/bash
    if ! systemctl is-enabled --quiet netbird 2>/dev/null; then
        sudo /usr/bin/netbird service install || true
    fi
    sudo /usr/bin/netbird service start || true
    echo "Netbird service installed and started."

# Stop and remove Netbird service
remove-netbird:
    #!/usr/bin/bash
    sudo /usr/bin/netbird service stop || true
    sudo /usr/bin/netbird service uninstall || true
    echo "Netbird service stopped and removed."
