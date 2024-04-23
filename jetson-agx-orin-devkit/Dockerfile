# Cuda Examples can't be compiled with newer glibc, see
# https://forums.developer.nvidia.com/t/cuda-11-5-samples-throw-multiple-error-attribute-malloc-does-not-take-arguments/192750

# AGX Orin, Orin NX and Orin Nano use the same T234 platform, therefore base images can be used
# interchangeably as long as nvidia.list contains the right apt repositoy
FROM balenalib/jetson-agx-orin-devkit-ubuntu:jammy-20240401

# Prevent apt-get prompting for input
ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb https://repo.download.nvidia.com/jetson/common r36.2 main" >  /etc/apt/sources.list.d/nvidia.list \
       && echo "deb https://repo.download.nvidia.com/jetson/t234 r36.2 main" >>  /etc/apt/sources.list.d/nvidia.list \
       && apt-key adv --fetch-key http://repo.download.nvidia.com/jetson/jetson-ota-public.asc \
       && mkdir -p /opt/nvidia/l4t-packages/ && touch /opt/nvidia/l4t-packages/.nv-l4t-disable-boot-fw-update-in-preinstall

# Download and install BSP binaries for L4T 35.4.1
RUN \
    apt-get update && apt-get install -y wget tar lbzip2 binutils xz-utils zstd qemu-user-static cpio && \
    cd /tmp/ && wget https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v2.0/release/jetson_linux_r36.2.0_aarch64.tbz2 && \
    tar xf jetson_linux_r36.2.0_aarch64.tbz2 && \
    cd Linux_for_Tegra && \
    sed -i 's/config.tbz2\"/config.tbz2\" --exclude=etc\/hosts --exclude=etc\/hostname/g' apply_binaries.sh && \
    sed -i 's/CheckPackage qemu-user-static/#CheckPackage qemu-user-static/g' apply_binaries.sh && \
    sed -i 's/trap CleanupVirEnv/#trap CleanupVirEnv/g' apply_binaries.sh && \
    sed -i 's|cp /usr/bin/qemu-aarch64-static|#cp /usr/bin/qemu-aarch64-static|g' apply_binaries.sh && \
    sed -i 's|cp /etc/resolv.conf|#cp /etc/resolv.conf|g' apply_binaries.sh && \
    sed -i 's|mv "${LDK_ROOTFS_DIR}/etc/resolv.conf"|cp "${LDK_ROOTFS_DIR}/etc/resolv.conf"|g' apply_binaries.sh && \
    sed -i 's|	PrepareVirEnv|#PrepareVirEnv|g' apply_binaries.sh && \
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
ENV UDEV=1

# Prevent screen from turning off
RUN echo "#!/bin/bash" > /etc/X11/xinit/xserverrc \
   && echo "" >> /etc/X11/xinit/xserverrc \
   && echo 'exec /usr/bin/X -s 0 dpms' >> /etc/X11/xinit/xserverrc

## If any apt packages install mesa-egl, it will overwrite the tegra-egl
## symlink and ld path, so the following command will ensure tegra-egl remains
## available:
# RUN \
#   echo "/usr/lib/aarch64-linux-gnu/tegra\n/usr/lib/aarch64-linux-gnu/tegra-egl" \
#   > /etc/ld.so.conf.d/000-nvidia-tegra-egl.conf \
#   && ldconfig

## Optional: Sample CUDA Clock sample run in webterminal:
##
##  apt-get update && apt-get install -y nvidia-l4t-cuda nvidia-cuda cuda-toolkit build-essential git && git clone https://github.com/NVIDIA/cuda-samples.git && cd cuda-samples/Samples/1_Utilities/deviceQuery/ && make && ./deviceQuery
##
##  Example Output:
##
# ./deviceQuery Starting...
#
#  CUDA Device Query (Runtime API) version (CUDART static linking)
#
#  Detected 1 CUDA Capable device(s)
#
#  Device 0: "Orin"
#   CUDA Driver Version / Runtime Version          12.2 / 12.2
#   CUDA Capability Major/Minor version number:    8.7
#   Total amount of global memory:                 30701 MBytes (32191905792 bytes)
#   (016) Multiprocessors, (128) CUDA Cores/MP:    2048 CUDA Cores
#   GPU Max Clock rate:                            1300 MHz (1.30 GHz)
#  ...
#  deviceQuery, CUDA Driver = CUDART, CUDA Driver Version = 12.2, CUDA Runtime Version = 12.2, NumDevs = 1
#  Result = PASS

## Start XFCE desktop

CMD ["startxfce4"]
