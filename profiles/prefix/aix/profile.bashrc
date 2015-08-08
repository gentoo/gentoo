# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# never use /bin/sh as CONFIG_SHELL on AIX: it is ways too slow,
# as well as broken in some corner cases.
export CONFIG_SHELL=${BASH}
