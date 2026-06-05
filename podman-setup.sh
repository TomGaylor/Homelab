# Check if podman command exists and version
which podman && podman --version

# Or more detailed
rpm -q podman

## Check if the Podman Socket / Service is Running ##
# User-level (recommended for Quadlets)
systemctl --user status podman.socket

# Or system-wide
systemctl status podman

# If the socket is not active, enable it:
systemctl --user enable --now podman.socket

# Test Podman
podman run --rm hello-world

# Quadlet-Specific Check
# Quadlet is built into Podman — there's no separate quadlet command. Test it by running:
/usr/libexec/podman/quadlet --user -dryrun
# If the directory exists and it runs without "command not found", you're good.

# For your Jellyfin setup, once Podman is confirmed:
# Run the volume generator script you have.
# Then run the following... (should be done in the main install)

# systemctl --user daemon-reload
# systemctl --user enable --now jellyfin.service









