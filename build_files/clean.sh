dnf clean all \
&& rm -rf /var/cache/* /var/lib/dnf/repos/* \
&& rm -rf /tmp/* /run/dnf /run/gluster /run/selinux-policy \
&& rm -rf /boot/* \
&& rm -rf /var/lib/dnf /var/lib/iscsi /var/lib/libvirt /var/lib/rpm-state /var/lib/swtpm-localca