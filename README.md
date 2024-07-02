Sample Application that uses X11 on the Jetson Platform

These samples are based on L4T 32.7.1/32.7.2/35.1/35.2.1/35.3.1/35.4.1/35.5.0/36.3 and they showcase installing X11 and Gstreamer packages in a privileged container.

Supported modules:

- Jetson Nano (SD-CARD, eMMC and 2GB variants)
- Jetson TX2
- Jetson TX2 NX
- Jetson AGX Orin
- Jetson Xavier AGX
- Jetson Xavier NX (both SD-CARD and eMMC variants)
- Jetson AGX Orin Devkit
- Jetson Orin NX in Xavier NX Devkit NVME
- Jetson Orin Nano 8GB (SD) Devkit NVME
- Jetson Orin Nano 4GB in Seeed J3010

These examples can also be used with device types that use third-party carrier boards.
The jetson-tx2 example targets both the Jetson TX2 and Jetson TX2 NX modules.
Similarly, the jetson-nano container is designed for the Nano SD, Nano eMMC and the Nano 4GB Devkit, while the Xavier NX example can be used
for both the Xavier NX SD-CARD and the Xavier NX eMMC.
The Jetson Orin NX example can be used on any Orin NX module regardless of the carrier board. Same for the Orin Nano 8GB example, which can be used on the Seeed J3010.

Please see the notes regarding CUDA samples installation, compiling and running. These are not installed
by default in the Dockerfiles in order to keep the image size as low as possible.

Please don't forget to ensure X is running and you have exported the DISPLAY variable before
running any tests or samples that use graphics.
