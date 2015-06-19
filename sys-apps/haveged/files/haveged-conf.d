# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/haveged/files/haveged-conf.d,v 1.1 2011/01/05 03:30:30 robbat2 Exp $

WATERMARK=1024

# -r0 is added always
HAVEGED_OPTS="-w ${WATERMARK} -v 1"

# vim:ft=gentoo-conf-d:
