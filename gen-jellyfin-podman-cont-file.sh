#!/bin/bash
# =============================================================================
# Jellyfin Quadlet Volume Generator for Bazzite
# Scans /var/mnt/ and creates Volume= entries for all mount points
# =============================================================================

MOUNT_DIR="/var/mnt"
QUADLET_FILE="$HOME/.config/containers/systemd/jellyfin.container"
BACKUP_FILE="${QUADLET_FILE}.bak.$(date +%Y%m%d-%H%M%S)"

echo "=== Jellyfin Quadlet Volume Generator ==="
echo "Scanning mount points in: $MOUNT_DIR"

# Check if mount directory exists
if [ ! -d "$MOUNT_DIR" ]; then
    echo "❌ Error: $MOUNT_DIR does not exist!"
    exit 1
fi

# Find all top-level directories in /var/mnt (skip hidden files)
MOUNTS=($(find "$MOUNT_DIR" -mindepth 1 -maxdepth 1 -type d | sort))

if [ ${#MOUNTS[@]} -eq 0 ]; then
    echo "⚠️  No mount points found in $MOUNT_DIR"
    exit 1
fi

echo "✅ Found ${#MOUNTS[@]} mount points:"

# Generate Volume lines
VOLUME_LINES=()
for mount in "${MOUNTS[@]}"; do
    name=$(basename "$mount")
    volume_line="Volume=$mount:/media/$name:ro,z"
    VOLUME_LINES+=("$volume_line")
    echo "   $volume_line"
done

echo -e "\n📝 Generated Volume entries above."

# Backup existing file if it exists
if [ -f "$QUADLET_FILE" ]; then
    cp "$QUADLET_FILE" "$BACKUP_FILE"
    echo "💾 Backup created: $BACKUP_FILE"
fi

# Create or update the quadlet file
cat > "$QUADLET_FILE" << 'EOF'
[Container]
ContainerName=jellyfin
Image=docker.io/jellyfin/jellyfin:latest
AutoUpdate=registry

# Ports
PublishPort=8096:8096/tcp
# PublishPort=7359:7359/udp

# Persistent data
Volume=%h/.jellyfin/config:/config:Z
Volume=%h/.jellyfin/cache:/cache:Z

EOF

# Append the generated volumes
for line in "${VOLUME_LINES[@]}"; do
    echo "$line" >> "$QUADLET_FILE"
done

cat >> "$QUADLET_FILE" << 'EOF'

# NVIDIA RTX 3070
AddDevice=nvidia.com/gpu=all
Environment=NVIDIA_VISIBLE_DEVICES=all
Environment=NVIDIA_DRIVER_CAPABILITIES=compute,utility,video

# Security / SELinux
SecurityLabelDisable=true

Environment=TZ=America/Phoenix
Environment=PUID=1000
Environment=PGID=1000

[Service]
Restart=always

[Install]
WantedBy=default.target
EOF

echo "✅ Quadlet file successfully updated: $QUADLET_FILE"
echo ""
echo "Next steps:"
echo "   systemctl --user daemon-reload"
echo "   systemctl --user restart jellyfin.service"
echo ""
echo "You can run this script again anytime new mounts are added."
