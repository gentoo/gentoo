# /etc/conf.d/chrome-remote-desktop: config file for /etc/init.d/chrome-remote-desktop

# List of users to start Chrome Remote Desktop for.
CHROME_REMOTING_USERS=''

# Options to pass to chrome-remote-desktop.  Only the -s option is interesting.
# Note: In order to support resizing, you need to:
# (1) Apply this patch to xorg-server (via epatch_user):
#     http://patchwork.freedesktop.org/patch/51428/
# (2) Create a symlink /usr/bin/Xvfb-randr -> Xvfb
#OPTIONS='-s 1600x1200 -s 3840x1600'

# Directory to use for storing log files.
#CHROME_REMOTE_DESKTOP_LOG_DIR='/var/log'
