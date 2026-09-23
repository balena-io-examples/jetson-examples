FROM ubuntu:noble-20260410

# Install extras and utilities
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

# Prevent apt-get prompting for input
ENV DEBIAN_FRONTEND noninteractive

# Install BSP binaries for L4T 39.2.0
RUN \
    cd /tmp/ && apt-get update && apt-get install -y wget tar lbzip2 binutils xz-utils zstd qemu-user-static cpio git vim && \
    wget https://developer.nvidia.com/downloads/embedded/L4T/r39_Release_v2.0/release/Jetson_Linux_R39.2.0_aarch64.tbz2 && \
    tar xf Jetson_Linux_R39.2.0_aarch64.tbz2 && \
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
    sed -i 's|  PrepareVirEnv|#PrepareVirEnv|g' tools/l4t_update_initrd.sh && \
    sed -i 's/install --owner=root --group=root \"${QEMU_BIN}\" \"${L4T_ROOTFS__DIR}\/usr\/bin\/\"/#install --owner=root --group=root \"${QEMU_BIN}\" \"${L4T_ROOTFS_DIR}\/usr\/bin\/\"/g' nv_tegra/nv-apply-debs.sh && \
    sed -i 's/chroot . \//  /g' nv_tegra/nv-apply-debs.sh && \
    rm -rf /etc/nv_tegra_release && \
    sed -i 's/tar ${TAR_ROOTFS_DIR_OPTS}/tar --overwrite ${TAR_ROOTFS_DIR_OPTS}/g' ./apply_binaries.sh && \
    rm -rf kernel/openrm/nvidia_l4t_kernel_openrm.tbz2 && \
    ./apply_binaries.sh -r / --target-overlay --openrm && \
    echo "/usr/lib/aarch64-linux-gnu/tegra" > /etc/ld.so.conf.d/nvidia-tegra.conf && ldconfig

RUN \
     echo "deb https://repo.download.nvidia.com/jetson/common r39.2 main" > /etc/apt/sources.list.d/nvidia-l4t-apt-source.list && \
     echo "deb https://repo.download.nvidia.com/jetson/som r39.2 main" >> /etc/apt/sources.list.d/nvidia-l4t-apt-source.list && \
     echo "deb https://repo.download.nvidia.com/jetson/ffmpeg r39.2 main" >> /etc/apt/sources.list.d/nvidia-l4t-apt-source.list && \
     apt-key adv --fetch-key http://repo.download.nvidia.com/jetson/jetson-ota-public.asc && \
     mkdir -p /opt/nvidia/l4t-packages/ && touch /opt/nvidia/l4t-packages/.nv-l4t-disable-boot-fw-update-in-preinstall && \
     cd /tmp//Linux_for_Tegra/ && ./nv_tegra/nv-apply-debs.sh --root / --openrm || true

WORKDIR /usr/src

RUN \
   apt-get install -y --no-install-recommends \
   xserver-xorg-input-evdev \
   xinit \
   xfce4 \
   xfce4-terminal \
   x11-xserver-utils \
   dbus-x11 \
   xterm

RUN mkdir -p /root/.config/xfce4/ && \
    cp -n /etc/xdg/xfce4/xinitrc /root/.config/xfce4/xinitrc && \
    sed -i '/#!\/bin\/sh/a \\n# Disable screen blanking \nxset s off\nxset s noblank\nxset -dpms' \
    /root/.config/xfce4/xinitrc && \
    chmod +x /root/.config/xfce4/xinitrc

# Uncomment lines below to install CUDA toolkit and samples
# Test GPU access by running /usr/src/cuda-samples/cpp/1_Utilities/deviceQuery/deviceQuery
#RUN apt-get update && \
#    apt-get install -y unzip cmake \
#    pkg-config \
#    build-essential cuda-toolkit-13-2 && \
#    git clone https://github.com/NVIDIA/cuda-samples.git && cd cuda-samples/cpp/1_Utilities/deviceQuery && \
#    cmake . -DCMAKE_CUDA_COMPILER=/usr/local/cuda-13.2/bin/nvcc -DCMAKE_CUDA_ARCHITECTURES=110 -DBUILD_TEGRA=True -DCMAKE_SYSROOT=/ -DCMAKE_C_COMPILER=/usr/bin/gcc  -DCMAKE_CXX_COMPILER=/usr/bin/g++ -DGPU_TARGETS=all -DCMAKE_BUILD_TYPE=Release && \
#    make
#ENV PATH="/usr/local/cuda-13.2/bin${PATH:+:${PATH}}"
#ENV LD_LIBRARY_PATH=/usr/lib/aarch64-linux-gnu/tegra:/opt/nvidia/l4t-gpu-libs/openrm

# Also uncomment lines below to install gstreamer packages
#RUN \
#    apt-get install -y -o Dpkg::Options::="--force-confnew" nvidia-l4t-multimedia nvidia-l4t-camera gstreamer1.0-tools gstreamer1.0-alsa \
#    gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
#    gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly \
#    gstreamer1.0-libav xfce4 libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-good1.0-dev nvidia-l4t-gstreamer && \
#    rm -rf ~/.cache/gstreamer-1.0/registry.*.bin && ldconfig
#ENV LD_LIBRARY_PATH="/usr/lib/aarch64-linux-gnu/gstreamer-1.0${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"

# To display video from a USB camera, run:
#export DISPLAY=:0
#    gst-launch-1.0 v4l2src device=/dev/video0 io-mode=2 do-timestamp=true ! \
#        queue max-size-buffers=1 leaky=downstream ! \
#        image/jpeg, width=1280, height=720, framerate=30/1 ! \
#        jpegparse ! \
#        nvjpegdec ! \
#        video/x-raw\(memory:NVMM\) ! \
#        nvvidconv ! \
#        "video/x-raw(memory:NVMM), format=NV12" ! \
#        nv3dsink sync=false

#To run a gstreamer test pipeline:
#export DISPLAY=:0
#gst-launch-1.0 videotestsrc ! queue ! nvvidconv ! nvegltransform ! nveglglessink -e

COPY entry.sh .
COPY startxfce.sh .

CMD ["/bin/bash", "/usr/src/entry.sh"]
