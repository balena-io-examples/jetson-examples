Sample Application that uses X11 on the Jetson Platform

These samples are based on L4T 32.4.4/32.5.1/32.6.1. They showcase installing X11 and Gstreamer packages
in a privileged container. The L4T version is present in each example Dockerfile, in the BSP archive name: "jetson_linux_r32.6.1_aarch64.tbz2".

Supported modules:

- Jetson Nano (SD-CARD, eMMC and 2GB variants)
- Jetson TX2 (currently on 32.5.1)
- Jetson TX2 NX (currently on 32.6.1)
- Jetson Xavier AGX
- Jetson Xavier NX (both SD-CARD and eMMC variants)

These examples can also be used with device types that use third-party carrier boards.


Please see the notes regarding CUDA samples installation, compiling and running. These are not installed
by default in the Dockerfiles in order to keep the image size as low as possible.

Please don't forget to ensure X is running and you have exported the DISPLAY variable before
running any tests or samples that use graphics.
