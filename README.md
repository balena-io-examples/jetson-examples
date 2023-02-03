Sample Application that uses X11 on the Jetson Platform

These samples are based on L4T 32.7.1/32.7.2 They showcase installing X11 and Gstreamer packages
in a privileged container.

Supported modules:

- Jetson Nano (SD-CARD, eMMC and 2GB variants)
- Jetson TX2
- Jetson TX2 NX
- Jetson AGX Orin
- Jetson Xavier AGX
- Jetson Xavier NX (both SD-CARD and eMMC variants)

These examples can also be used with device types that use third-party carrier boards.
The jetson-tx2 example targets both the Jetson TX2 and Jetson TX2 NX modules.
Similarly, the jetson-nano container is designed for the Nano SD, Nano eMMC and the Nano 4GB Devkit, while the Xavier NX example can be used
for both the Xavier NX SD-CARD and the Xavier NX eMMC.

Please see the notes regarding CUDA samples installation, compiling and running. These are not installed
by default in the Dockerfiles in order to keep the image size as low as possible.

Please don't forget to ensure X is running and you have exported the DISPLAY variable before
running any tests or samples that use graphics.
