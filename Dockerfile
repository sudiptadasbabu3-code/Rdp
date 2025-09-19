# Use an official QEMU base image
FROM multiarch/qemu-user-static:register

# Install necessary packages
RUN apt-get update && apt-get install -y \
    qemu-system-x86 \
    tightvncserver \
    novnc \
    && rm -rf /var/lib/apt/lists/*

# Download and set up Windows 11 ISO
RUN wget -O windows11.iso "https://archive.org/download/tiny-11-NTDEV/tiny11%20b2%28no%20sysreq%29.iso/path/to/windows11.iso" \
    && mkdir -p /windows11

# Set up the VNC server
RUN mkdir -p /root/.vnc
RUN echo "password" > /root/.vnc/passwd
RUN chmod 600 /root/.vnc/passwd

# Start the VNC server
RUN vncserver :1 -geometry 1280x800 -depth 24

# Set up noVNC
RUN mkdir -p /usr/local/share/novnc
COPY novnc/ /usr/local/share/novnc/

# Expose the necessary ports
EXPOSE 5901 6901

# Start the VNC server and noVNC
CMD ["sh", "-c", "vncserver :1 -geometry 1280x800 -depth 24 && noVNC/utils/launch.sh --vnc localhost:5901"]
