# AGX Orin, Orin NX and Orin Nano use the same T234 platform, therefore base images can be used
# interchangeably as long as nvidia.list contains the right apt repositoy
# FROM balenalib/jetson-orin-nano-devkit-nvme-ubuntu:jammy-20240401
FROM ubuntu:jammy-20250404

# Prevent apt-get prompting for input
ENV DEBIAN_FRONTEND noninteractive

# Install some dependencies/utils that were part of balenalib
RUN apt-get update && apt-get install -y --no-install-recommends \
  sudo \
  ca-certificates \
  findutils \
  gnupg \
  dirmngr \
  inetutils-ping \
  netbase \
  curl \
  udev \
  kmod \
  nano
  
RUN echo "deb https://repo.download.nvidia.com/jetson/common r36.4 main" >  /etc/apt/sources.list.d/nvidia.list \
       && echo "deb https://repo.download.nvidia.com/jetson/t234 r36.4 main" >>  /etc/apt/sources.list.d/nvidia.list \
       && apt-key adv --fetch-key http://repo.download.nvidia.com/jetson/jetson-ota-public.asc \
       && mkdir -p /opt/nvidia/l4t-packages/ && touch /opt/nvidia/l4t-packages/.nv-l4t-disable-boot-fw-update-in-preinstall

# Download and install BSP binaries for L4T 36.4.3 - Jetpack 6.2
RUN \
    apt-get update && apt-get install -y wget tar lbzip2 binutils xz-utils zstd qemu-user-static cpio git && \
    cd /tmp/ && wget https://developer.nvidia.com/downloads/embedded/l4t/r36_release_v4.3/release/Jetson_Linux_r36.4.3_aarch64.tbz2 && \
    tar xf Jetson_Linux_r36.4.3_aarch64.tbz2 && \
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

ENV LD_LIBRARY_PATH=/usr/lib/aarch64-linux-gnu/tegra
ENV UDEV=1

RUN \
   echo "/usr/lib/aarch64-linux-gnu/tegra\n/usr/lib/aarch64-linux-gnu/tegra-egl" \
   > /etc/ld.so.conf.d/000-nvidia-tegra-egl.conf \
   && ldconfig

RUN apt-get update && \
    apt-get install -y -o Dpkg::Options::="--force-confnew" nvidia-l4t-x11 xserver-xorg-video-nvidia-545 gstreamer1.0-tools \
    gstreamer1.0-alsa gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav && \
    apt-get install -y -o Dpkg::Options::="--force-confnew" libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-good1.0-dev libgstreamer-plugins-bad1.0-dev && \
    apt-get install -y -o Dpkg::Options::="--force-confnew" nvidia-l4t-gstreamer && ldconfig && rm -rf .cache/gstreamer-1.0/

COPY ./startxfce.sh /opt/startxfce.sh
COPY ./entry.sh /opt/entry.sh

CMD ["/bin/bash", "/opt/entry.sh"]
