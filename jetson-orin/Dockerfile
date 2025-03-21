# AGX Orin, Orin NX and Orin Nano use the same T234 platform, therefore base images can be used
# interchangeably as long as nvidia.list contains the right apt repositoy
FROM balenalib/jetson-orin-nano-devkit-nvme-ubuntu:jammy-20240401

# Prevent apt-get prompting for input
ENV DEBIAN_FRONTEND noninteractive

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
   echo 'modules=("tegra_drm" "nvidia_drm" "nvidia_modeset"); for module in "${modules[@]}"; do if lsmod | grep -q ${module} ; then echo "Found $module"; rmmod $module; fi; done; startxfce4 & sleep 5; modprobe tegra_drm; modprobe nvidia_drm; while [ 1 ]; do sleep 10; done; ' > /opt/startxfce.sh

## If any apt packages install mesa-egl, it will overwrite the tegra-egl
## symlink and ld path, so the following command will ensure tegra-egl remains
## available:
# RUN \
#   echo "/usr/lib/aarch64-linux-gnu/tegra\n/usr/lib/aarch64-linux-gnu/tegra-egl" \
#   > /etc/ld.so.conf.d/000-nvidia-tegra-egl.conf \
#   && ldconfig

## Optional: Sample CUDA Clock sample run in webterminal:
##  apt-get update && apt-get install -y -o Dpkg::Options::="--force-confdef" nvidia-l4t-cuda nvidia-cuda build-essential cuda-nvcc-12-6 && git clone https://github.com/NVIDIA/cuda-samples.git && cd cuda-samples && git checkout 7ce058b4796783b3b7ca8196c25d5f5b9c380ec4 && cd Samples/1_Utilities/deviceQuery && make && modprobe tegra_drm && ./deviceQuery

## CUDA Device Query (Runtime API) version (CUDART static linking)
##
## Detected 1 CUDA Capable device(s)
##
## Device 0: "Orin"
##  CUDA Driver Version / Runtime Version          12.6 / 12.6
##  CUDA Capability Major/Minor version number:    8.7
##  Total amount of global memory:                 7623 MBytes (7993061376 bytes)
##  (008) Multiprocessors, (128) CUDA Cores/MP:    1024 CUDA Cores
##  GPU Max Clock rate:                            1020 MHz (1.02 GHz)
##  Memory Clock rate:                             612 Mhz
##  Memory Bus Width:                              128-bit
##  L2 Cache Size:                                 2097152 bytes
##  Maximum Texture Dimension Size (x,y,z)         1D=(131072), 2D=(131072, 65536), 3D=(16384, 16384, 16384)
##  Maximum Layered 1D Texture Size, (num) layers  1D=(32768), 2048 layers
##  Maximum Layered 2D Texture Size, (num) layers  2D=(32768, 32768), 2048 layers
##  Total amount of constant memory:               65536 bytes
##  Total amount of shared memory per block:       49152 bytes
##  Total shared memory per multiprocessor:        167936 bytes
##  Total number of registers available per block: 65536
##  Warp size:                                     32
##  Maximum number of threads per multiprocessor:  1536
##  Maximum number of threads per block:           1024
##  Max dimension size of a thread block (x,y,z): (1024, 1024, 64)
##  Max dimension size of a grid size    (x,y,z): (2147483647, 65535, 65535)
##  Maximum memory pitch:                          2147483647 bytes
##  Texture alignment:                             512 bytes
##  Concurrent copy and kernel execution:          Yes with 2 copy engine(s)
##  Run time limit on kernels:                     No
##  Integrated GPU sharing Host Memory:            Yes
##  Support host page-locked memory mapping:       Yes
##  Alignment requirement for Surfaces:            Yes
##  Device has ECC support:                        Disabled
##  Device supports Unified Addressing (UVA):      Yes
##  Device supports Managed Memory:                Yes
##  Device supports Compute Preemption:            Yes
##  Supports Cooperative Kernel Launch:            Yes
##  Supports MultiDevice Co-op Kernel Launch:      Yes
##  Device PCI Domain ID / Bus ID / location ID:   0 / 0 / 0
##  Compute Mode:
##     < Default (multiple host threads can use ::cudaSetDevice() with device simultaneously) >
##
## deviceQuery, CUDA Driver = CUDART, CUDA Driver Version = 12.6, CUDA Runtime Version = 12.6, NumDevs = 1
## Result = PASS

CMD ["/bin/bash", "/opt/startxfce.sh"]

