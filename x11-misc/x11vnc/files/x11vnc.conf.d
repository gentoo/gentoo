# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Configuration for running x11vnc as a service. This allows VNC 
# connections prior to logging in to the X display manager.

# Password file location of the password file for VNC Connections
#   Prior to first run, you must configure a password, to do so please
#   run `x11vnc -storepasswd /etc/x11vnc.pass`. Replace /etc/x11vnc.pass 
#   ith the location you have specified below
#X11VNC_RFBAUTH="/etc/x11vnc.pass"

# Port to listen on for incoming connections
#X11VNC_RFBPORT="5900"

# Automatically probe for a free port to listen on for incoming connections
# starting from the port number specified
#   Setting this will diable X11VNC_RFBPORT above
#   See `man x11vnc`, option `-autoport` for more information
#X11VNC_AUTOPORT=""

# X Display to attach to
#   This should match the display your DM is running on
#X11VNC_DISPLAY=":0"

# Location of the x11vnc logfile
#X11VNC_LOG="/var/log/x11vnc"

# Miscelaneous options to pass to x11vnc.
#   Do not set options that are configurable above.
#   Check `x11vnc -help` or `man x11vnc` for more options.
#   * Modern composting DMs/WMs will require "-noxdamage"
#   * If you experience crashes on logging in, try "-noxfixes"
#   * Other suggested options include "-noxrecord" and "-ncache ##"
#     Refer to the x11vnc man page for further explanations.
#X11VNC_OPTS=""

