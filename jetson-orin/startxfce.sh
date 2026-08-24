#!/bin/bash

# Ensure plymouth exited
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
 
# Prevent "Server is already active for display 0"  error,
# in case X was forcedly closed before
rm -rf /tmp/.X0-lock* || true

# Prevent black screen with cursor only
rm -rf /root/.config/ || true

startxfce4

echo "Sleeping..."
while [ 1 ]; do
   sleep 10;
done;

