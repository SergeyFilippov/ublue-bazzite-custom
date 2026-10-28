# Install and start Netbird service
setup-netbird:
    #!/usr/bin/bash
    if ! systemctl is-enabled --quiet netbird 2>/dev/null; then
        sudo /usr/bin/netbird service install || true
    fi
    sudo /usr/bin/netbird service start || true
    sudo systemctl enable --now netbird.service
    echo "Netbird service installed and started."

# Stop and remove Netbird service
remove-netbird:
    #!/usr/bin/bash
    sudo systemctl disable --now netbird.service
    sudo /usr/bin/netbird service stop || true
    sudo /usr/bin/netbird service uninstall || true
    echo "Netbird service stopped and removed."

# Install and start ZeroTier service (optionally applying config_dir and joining network_id)
setup-zerotier config_dir="" network_id="":
    #!/usr/bin/bash
    set -euo pipefail
    sudo systemd-tmpfiles --create /usr/lib/tmpfiles.d/zerotier-one.conf 2>/dev/null || true
    sudo mkdir -p /var/lib/zerotier-one/moons.d
    if [[ -n "{{ config_dir }}" ]]; then
        ujust configure-zerotier "{{ config_dir }}"
    fi
    sudo systemctl enable --now zerotier-one.service
    if [[ -n "{{ config_dir }}" ]]; then
        sudo systemctl restart zerotier-one.service
    fi
    if [[ -n "{{ network_id }}" ]]; then
        for _ in {1..10}; do
            if sudo test -f /var/lib/zerotier-one/authtoken.secret; then
                break
            fi
            sleep 0.5
        done
        sudo zerotier-cli join "{{ network_id }}"
    fi
    echo "ZeroTier service enabled and started."

# Copy custom local.conf and/or .moon files into /var/lib/zerotier-one
configure-zerotier config_path="":
    #!/usr/bin/bash
    set -euo pipefail
    target_path="{{ config_path }}"
    if [[ -z "${target_path}" ]]; then
        read -rp "Enter path to directory or file (local.conf / .moon): " target_path
    fi
    target_path="${target_path/#\~/$HOME}"
    if [[ ! -e "${target_path}" ]]; then
        echo "Error: Path '${target_path}' does not exist." >&2
        exit 1
    fi
    sudo systemd-tmpfiles --create /usr/lib/tmpfiles.d/zerotier-one.conf 2>/dev/null || true
    sudo mkdir -p /var/lib/zerotier-one/moons.d
    copied_any=0
    if [[ -d "${target_path}" ]]; then
        if [[ -f "${target_path}/local.conf" ]]; then
            sudo install -m 0644 -o root -g root "${target_path}/local.conf" /var/lib/zerotier-one/local.conf
            echo "Installed /var/lib/zerotier-one/local.conf"
            copied_any=1
        fi
        shopt -s nullglob
        moon_files=("${target_path}"/*.moon "${target_path}"/moons.d/*.moon)
        shopt -u nullglob
        for moon in "${moon_files[@]}"; do
            sudo install -m 0644 -o root -g root "${moon}" /var/lib/zerotier-one/moons.d/
            echo "Installed moon: /var/lib/zerotier-one/moons.d/$(basename "${moon}")"
            copied_any=1
        done
    elif [[ -f "${target_path}" ]]; then
        filename="$(basename "${target_path}")"
        if [[ "${filename}" == "local.conf" ]]; then
            sudo install -m 0644 -o root -g root "${target_path}" /var/lib/zerotier-one/local.conf
            echo "Installed /var/lib/zerotier-one/local.conf"
            copied_any=1
        elif [[ "${filename}" == *.moon ]]; then
            sudo install -m 0644 -o root -g root "${target_path}" /var/lib/zerotier-one/moons.d/
            echo "Installed moon: /var/lib/zerotier-one/moons.d/${filename}"
            copied_any=1
        else
            echo "Error: File must be named 'local.conf' or '*.moon'." >&2
            exit 1
        fi
    fi
    if [[ "${copied_any}" -eq 0 ]]; then
        echo "Warning: No 'local.conf' or '*.moon' files found in '${target_path}'." >&2
        exit 1
    fi
    if systemctl is-active --quiet zerotier-one.service; then
        sudo systemctl restart zerotier-one.service
        echo "Restarted zerotier-one.service to apply changes."
    fi

# Stop and disable ZeroTier service
remove-zerotier:
    #!/usr/bin/bash
    sudo systemctl disable --now zerotier-one.service
    echo "ZeroTier service stopped and disabled."
