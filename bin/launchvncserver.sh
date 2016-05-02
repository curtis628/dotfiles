#!/bin/bash

# Start VNC Server on display :1
vncserver :1 -geometry 1920x1080 -depth 24

# We can stop display manager running on :0
service lightdm stop
