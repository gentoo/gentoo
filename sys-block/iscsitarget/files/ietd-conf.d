# Copyright 1999-2006 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Id$

# Address and port to listen on for connections.
#ADDRESS="" # set this to non-empty to listen somewhere specific
PORT=3260

# Address of your SNS server
# if available
#ISNS=""

# User and group to run as
# You must ensure that the UID/GID have access to the files/devices you
# have provided in your configuration.
USER="root"
GROUP="root"

# Debug level - see ietd(8) for the levels
#DEBUGLEVEL=

# This setting disables the memory configuration warnings.
# Upstream takes the general policy of forcing all of the memory settings that
# they want, but that doesn't mesh with users that have it set higher.
# Gentoo by default ignores the settings that are higher, but issues warnings
# on those that are lower.
# Uncomment the next line to disable those warnings.
#DISABLE_MEMORY_WARNINGS=1

# vim: filetype=gentoo-conf-d tw=72:
