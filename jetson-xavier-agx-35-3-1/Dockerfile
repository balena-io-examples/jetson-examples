# Cuda Examples can't be compiled with newer glibc, see
# https://forums.developer.nvidia.com/t/cuda-11-5-samples-throw-multiple-error-attribute-malloc-does-not-take-arguments/192750

FROM balenalib/jetson-xavier-ubuntu:focal

# Prevent apt-get prompting for input
ENV DEBIAN_FRONTEND noninteractive

# The generic Jetson Xavier device-type has base images running L4T 32.7. However, this CDS AGX Xavier is based on L4T
# 35.3.1 and thus we replace the sources.list contents to specify the 35.3 repositories for the t194 platform
RUN echo "deb https://repo.download.nvidia.com/jetson/common r35.3 main" >  /etc/apt/sources.list.d/nvidia.list \
	&& echo "deb https://repo.download.nvidia.com/jetson/t194 r35.3 main" >>  /etc/apt/sources.list.d/nvidia.list \
	&& apt-key adv --fetch-key http://repo.download.nvidia.com/jetson/jetson-ota-public.asc \
	&& mkdir -p /opt/nvidia/l4t-packages/ && touch /opt/nvidia/l4t-packages/.nv-l4t-disable-boot-fw-update-in-preinstall

# Download, unpack and apply the BSP binaries for L4T 35.3.1 in this container image
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


## Optional: GPU access from container with the Sample CUDA Clock application run in webterminal:
##  apt-get update && apt-get install nvidia-l4t-cuda nvidia-cuda cuda-samples-11-4 && cd /usr/local/cuda-11.4/samples/0_Simple/clock/ && make && ./clock
##  Output:
##
## CUDA Clock sample
## GPU Device 0: "Xavier" with compute capability 7.2

## Other test application:
## root@770d3d8:/usr/local/cuda-11.4/samples/0_Simple/simpleMultiGPU# make
## root@770d3d8:/usr/local/cuda-11.4/samples/0_Simple/simpleMultiGPU# ./simpleMultiGPU 
## Starting simpleMultiGPU
## CUDA-capable device count: 1
## Generating input data...
##
## Computing with 1 GPUs...
##  GPU Processing time: 33.534000 (ms)
##
## Computing with Host CPU...
##
## Comparing GPU and Host CPU results...
##  GPU sum: 16777296.000000
##  CPU sum: 16777294.395033
##  Relative difference: 9.566307E-08


# Start XFCE desktop

CMD ["startxfce4"]
