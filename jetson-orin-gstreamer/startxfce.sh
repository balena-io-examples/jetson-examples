#!/bin/bash

# Ensure plymouth is stopped so nvidia_drm to be unloaded before starting X
DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket \
  dbus-send \
  --system \
  --print-reply \
  --dest=org.freedesktop.systemd1 \
  /org/freedesktop/systemd1 \
  org.freedesktop.systemd1.Manager.StopUnit \
  string:plymouth-start.service string:replace

DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket \
  dbus-send \
  --system \
  --print-reply \
  --dest=org.freedesktop.systemd1 \
  /org/freedesktop/systemd1 \
  org.freedesktop.systemd1.Manager.StopUnit \
  string:plymouth-read-write.service string:replace
  
sleep 5

rmmod nvidia_drm

sleep 2

X

while [ 1 ]; do sleep 10; done;
