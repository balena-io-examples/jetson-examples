# AGX Orin, Orin NX and Orin Nano use the same T234 platform, therefore base images can be used
# interchangeably as long as nvidia.list contains the right apt repositoy
FROM balenalib/jetson-orin-nx-xavier-nx-devkit-ubuntu:jammy-20240401

# Prevent apt-get prompting for input
ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb https://repo.download.nvidia.com/jetson/common r36.3 main" >  /etc/apt/sources.list.d/nvidia.list \
       && echo "deb https://repo.download.nvidia.com/jetson/t234 r36.3 main" >>  /etc/apt/sources.list.d/nvidia.list \
       && apt-key adv --fetch-key http://repo.download.nvidia.com/jetson/jetson-ota-public.asc \
       && mkdir -p /opt/nvidia/l4t-packages/ && touch /opt/nvidia/l4t-packages/.nv-l4t-disable-boot-fw-update-in-preinstall

# Download and install BSP binaries for L4T 36.3 - Jetpack 6
RUN \
    apt-get update && apt-get install -y wget tar lbzip2 binutils xz-utils zstd qemu-user-static cpio git && \
    cd /tmp/ && wget https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v3.0/release/jetson_linux_r36.3.0_aarch64.tbz2 && \
    tar xf jetson_linux_r36.3.0_aarch64.tbz2 && \
    cd Linux_for_Tegra && \
    mkdir -p /tmp/Linux_for_Tegra/rootfs/boot/ && \
    mkdir -p /tmp/Linux_for_Tegra/rootfs/usr/bin && \
    mkdir -p /tmp/Linux_for_Tegra/rootfs/etc && touch /tmp/Linux_for_Tegra/rootfs/etc/resolv.conf && \
    sed -i 's/config.tbz2\"/config.tbz2\" --exclude=etc\/hosts --exclude=etc\/hostname/g' apply_binaries.sh && \
    sed -i 's/CheckPackage qemu-user-static/#CheckPackage qemu-user-static/g' tools/l4t_update_initrd.sh && \
    sed -i 's/trap CleanupVirEnv/#trap CleanupVirEnv/g' tools/l4t_update_initrd.sh&& \
    sed -i 's|cp /usr/bin/qemu-aarch64-static|#cp /usr/bin/qemu-aarch64-static|g' tools/l4t_update_initrd.sh && \
    sed -i 's|^UpdateInitrd|#UpdateInitrd|g' tools/l4t_update_initrd.sh && \
    sed -i 's|^UpdateBackToBaseInitrd|#UpdateBackToBaseInitrd|g' tools/l4t_update_initrd.sh && \
    sed -i 's|cp /etc/resolv.conf|#cp /etc/resolv.conf|g' tools/l4t_update_initrd.sh && \
    sed -i 's|mv "${LDK_ROOTFS_DIR}/etc/resolv.conf"|cp "${LDK_ROOTFS_DIR}/etc/resolv.conf"|g' tools/l4t_update_initrd.sh && \
    sed -i 's|	PrepareVirEnv|#PrepareVirEnv|g' tools/l4t_update_initrd.sh && \
    sed -i 's/install --owner=root --group=root \"${QEMU_BIN}\" \"${L4T_ROOTFS_DIR}\/usr\/bin\/\"/#install --owner=root --group=root \"${QEMU_BIN}\" \"${L4T_ROOTFS_DIR}\/usr\/bin\/\"/g' nv_tegra/nv-apply-debs.sh && \
    sed -i 's/chroot . \//  /g' nv_tegra/nv-apply-debs.sh && \
    cd /tmp/Linux_for_Tegra/ && ./apply_binaries.sh -r / --target-overlay && cd .. && \
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
   && echo 'exec /usr/bin/X -s 0 dpms' >> /etc/X11/xinit/xserverrc && \
   echo 'modules=("nvidia_drm" "nvidia_modeset"); for module in "${modules[@]}"; do if lsmod | grep -q ${module} ; then echo "Found $module"; rmmod $module; fi; done; startxfce4;' > /opt/startxfce.sh

## If any apt packages install mesa-egl, it will overwrite the tegra-egl
## symlink and ld path, so the following command will ensure tegra-egl remains
## available:
# RUN \
#   echo "/usr/lib/aarch64-linux-gnu/tegra\n/usr/lib/aarch64-linux-gnu/tegra-egl" \
#   > /etc/ld.so.conf.d/000-nvidia-tegra-egl.conf \
#   && ldconfig

## Optional: Sample CUDA Clock sample run in webterminal:
##  apt-get update && apt-get install -y -o Dpkg::Options::="--force-confdef" nvidia-l4t-cuda nvidia-cuda build-essential cuda-nvcc-12-2 && git clone https://github.com/NVIDIA/cuda-samples.git && cd cuda-samples/Samples/1_Utilities/deviceQuery && make && ./deviceQuery
##  Example Output:
##
##./deviceQuery Starting...
##
## CUDA Device Query (Runtime API) version (CUDART static linking)
##
## Detected 1 CUDA Capable device(s)
##
## Device 0: "Orin"
##  CUDA Driver Version / Runtime Version          12.2 / 12.2
##  CUDA Capability Major/Minor version number:    8.7
##  Total amount of global memory:                 30701 MBytes (32191983616 bytes)
##  (008) Multiprocessors, (128) CUDA Cores/MP:    1024 CUDA Cores
##  GPU Max Clock rate:                            1300 MHz (1.30 GHz)
##  Memory Clock rate:                             612 Mhz
##  Memory Bus Width:                              256-bit
##  L2 Cache Size:                                 4194304 bytes
## ...
## deviceQuery, CUDA Driver = CUDART, CUDA Driver Version = 12.2, CUDA Runtime Version = 12.2, NumDevs = 1
## Result = PASS

# To start the XFCE desktop, the script called below does `rmmod nvidia_drm && rmmod nvidia_modeset && startxfce4`

CMD ["/bin/bash", "/opt/startxfce.sh"]
