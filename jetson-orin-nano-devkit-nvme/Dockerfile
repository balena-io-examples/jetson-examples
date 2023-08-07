# Cuda Examples can't be compiled with newer glibc, see
# https://forums.developer.nvidia.com/t/cuda-11-5-samples-throw-multiple-error-attribute-malloc-does-not-take-arguments/192750

# AGX Orin, Orin NX and Orin Nano use the same T234 platform, therefore base images can be used
# interchangeably as long as nvidia.list contains the right apt repository

# If Orin Nano Devkit NVME base images are not published yet,
# the AGX Orin ones can be used, since both are using the T234 platform, i.e:
# FROM balenalib/jetson-agx-orin-devkit-ubuntu:focal
FROM balenalib/jetson-orin-nano-devkit-nvme-ubuntu:focal

# Prevent apt-get prompting for input
ENV DEBIAN_FRONTEND noninteractive

# Uncomment line below to update debs repository from 35.1 to 35.3 if using a agx-orin-devkit base image
# RUN sed -i 's/r35.1 main/r35.3 main/g' /etc/apt/sources.list.d/nvidia.list

# Download and install BSP binaries for L4T 35.3.1
RUN \
    apt-get update && apt-get install -y wget tar lbzip2 binutils xz-utils zstd && \
    cd /tmp/ && wget https://developer.nvidia.com/downloads/embedded/l4t/r35_release_v3.1/release/jetson_linux_r35.3.1_aarch64.tbz2/ -O jetson_linux_r35.3.1_aarch64.tbz2 && \
    tar xf jetson_linux_r35.3.1_aarch64.tbz2 && \
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
## CUDA Clock sample
## GPU Device 0: "Ampere" with compute capability 8.7
##
## Average clocks/block = 1965.765625

# Start XFCE desktop

CMD ["startxfce4"]