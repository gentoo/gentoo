# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# This is the interval between runs of the clrngd main loop. It should NOT be
# less than 60 seconds (the daemon will exit with an error) as the main loop
# takes at least a minute to run. 240 seconds (4 minutes) is the default and
# recommended value.
DELAYTIME="240"
