#!/bin/bash

# Ensure plymouth exited so that it won't hold /dev/fb0 open and tegra_drm can be unloaded
DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket \
  dbus-send \
  --system \
  --print-reply \
  --dest=org.freedesktop.systemd1 \
  /org/freedesktop/systemd1 \
  org.freedesktop.systemd1.Manager.StopUnit \
  string:plymouth-start.service string:replace

# Give some time for plymouth to stop
sleep 2
 
# Prevent "Server is already active for display 0" error,
# in case X was forcedly closed before
rm -rf /tmp/.X0-lock* || true

# Prevent black screen with cursor only
rm -rf /root/.config/ || true

# Reload nvidia drm modules to drop any
# configuration plymouth may have used
modules=("tegra_drm" "nvidia_drm" "nvidia_modeset"); for module in "${modules[@]}";
do
    if lsmod | grep -q ${module} ; then
        echo "Found $module"; rmmod $module;
    fi;
done;

modprobe tegra_drm;
modprobe nvidia_drm;

sleep 1

startxfce4

while [ 1 ]; do
   sleep 10;
done;
