# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/lndir/lndir-1.0.2.ebuild,v 1.6 2011/02/14 14:46:18 xarthisius Exp $

EAPI=3

XORG_STATIC=no
inherit xorg-2

DESCRIPTION="create a shadow directory of symbolic links to another directory tree"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
		x11-proto/xproto"
