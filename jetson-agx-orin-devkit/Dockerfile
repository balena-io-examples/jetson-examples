# Cuda Examples can't be compiled with newer glibc, see
# https://forums.developer.nvidia.com/t/cuda-11-5-samples-throw-multiple-error-attribute-malloc-does-not-take-arguments/192750
FROM balenalib/jetson-agx-orin-devkit-ubuntu:focal

# Prevent apt-get prompting for input
ENV DEBIAN_FRONTEND noninteractive

# Download and install BSP binaries for L4T 35.1
RUN \
    apt-get update && apt-get install -y wget tar lbzip2 binutils xz-utils zstd && \
    cd /tmp/ && wget https://developer.nvidia.com/embedded/l4t/r35_release_v1.0/release/jetson_linux_r35.1.0_aarch64.tbz2 && \
    tar xf jetson_linux_r35.1.0_aarch64.tbz2 && \
    cd Linux_for_Tegra && \
    sed -i 's/config.tbz2\"/config.tbz2\" --exclude=etc\/hosts --exclude=etc\/hostname/g' apply_binaries.sh && \
    sed -i 's/install --owner=root --group=root \"${QEMU_BIN}\" \"${L4T_ROOTFS_DIR}\/usr\/bin\/\"/#install --owner=root --group=root \"${QEMU_BIN}\" \"${L4T_ROOTFS_DIR}\/usr\/bin\/\"/g' nv_tegra/nv-apply-debs.sh && \
    sed -i 's/chroot . \//  /g' nv_tegra/nv-apply-debs.sh && \
    ./apply_binaries.sh -r / --target-overlay && cd .. \
    rm -rf Linux_for_Tegra && \
    echo "/usr/lib/aarch64-linux-gnu/tegra" > /etc/ld.so.conf.d/nvidia-tegra.conf && ldconfig

## Install X and xfce
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
ENV UDEV=1

# Prevent screen from turning off
RUN echo "#!/bin/bash" > /etc/X11/xinit/xserverrc \
  && echo "" >> /etc/X11/xinit/xserverrc \
  && echo 'exec /usr/bin/X -s 0 dpms' >> /etc/X11/xinit/xserverrc


## Optional: Sample CUDA Clock sample run in webterminal:
##  apt-get update && apt-get install nvidia-l4t-cuda nvidia-cuda cuda-samples-11-4 && cd /usr/local/cuda-11.4/samples/0_Simple/clock/ && make && ./clock
##  Output:
##   CUDA Clock sample
##   GPU Device 0: "Xavier" with compute capability 7.2
##
##   Average clocks/block = 3171.421875

# Start XFCE desktop

CMD ["startxfce4"]
