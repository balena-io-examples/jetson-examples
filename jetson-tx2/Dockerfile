FROM balenalib/jetson-tx2-ubuntu:bionic

# Prevent apt-get prompting for input
ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's/r32.6 main/r32.7 main/g' /etc/apt/sources.list.d/nvidia.list

# Download and install BSP binaries for L4T 32.7.2, as well as a few gstreamer packages for the purpose of running sample playback videos with gst-launch
RUN \
    apt-get update && apt-get install -y wget tar lbzip2 \
    nvidia-l4t-gstreamer \
    libgstreamer1.0-0 gstreamer1.0-plugins-base \
    gobject-introspection gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-tools && \
    cd /tmp/ && wget https://developer.nvidia.com/embedded/l4t/r32_release_v7.2/t186/jetson_linux_r32.7.2_aarch64.tbz2 && \
    tar xf jetson_linux_r32.7.2_aarch64.tbz2 && rm jetson_linux_r32.7.2_aarch64.tbz2&& \
    cd Linux_for_Tegra && \
    sed -i 's/config.tbz2\"/config.tbz2\" --exclude=etc\/hosts --exclude=etc\/hostname/g' apply_binaries.sh && \
    sed -i 's/install --owner=root --group=root \"${QEMU_BIN}\" \"${L4T_ROOTFS_DIR}\/usr\/bin\/\"/#install --owner=root --group=root \"${QEMU_BIN}\" \"${L4T_ROOTFS_DIR}\/usr\/bin\/\"/g' nv_tegra/nv-apply-debs.sh && \
    sed -i 's/chroot . \//  /g' nv_tegra/nv-apply-debs.sh && \
    ./apply_binaries.sh -r / --target-overlay && cd .. \
    rm -rf Linux_for_Tegra && \
    echo "/usr/lib/aarch64-linux-gnu/tegra" > /etc/ld.so.conf.d/nvidia-tegra.conf && ldconfig

# Install X and xfce
RUN \
  apt-get install -y --no-install-recommends \
  xserver-xorg-input-evdev \
  xinit \
  xfce4 \
  xfce4-terminal \
  x11-xserver-utils \
  dbus-x11 \
  xterm

ENV LD_LIBRARY_PATH=/usr/lib/aarch64-linux-gnu/tegra
ENV XFCE_PANEL_MIGRATE_DEFAULT=1
ENV UDEV=1

# Prevent screen from turning off
RUN echo "#!/bin/bash" > /etc/X11/xinit/xserverrc \
  && echo "" >> /etc/X11/xinit/xserverrc \
  && echo 'exec /usr/bin/X -s 0 dpms' >> /etc/X11/xinit/xserverrc

## Optional: Sample Gstreamer playback in webterminal:
## $ export DISPLAY=0.0
## $ gst-launch-1.0 filesrc location="file_example.mp4" ! qtdemux name=demux ! h264parse ! omxh264dec ! nvoverlaysink -e
##
## Optional: Sample CUDA Clock sample run in webterminal:
##  apt-get install nvidia-l4t-cuda nvidia-cuda cuda-samples-10-2 && cd /usr/local/cuda-10.2/samples/0_Simple/clock/ && make && ./clock

# Start XFCE desktop
CMD ["startx"]

