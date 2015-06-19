# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xdbedizzy/xdbedizzy-1.1.0.ebuild,v 1.8 2011/02/14 23:05:12 xarthisius Exp $

EAPI=3

inherit xorg-2

DESCRIPTION="X.Org xdbedizzy application"
KEYWORDS="amd64 arm ~mips ppc ppc64 s390 sh ~sparc x86"
IUSE=""

RDEPEND="x11-libs/libXext
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-proto/xproto"
