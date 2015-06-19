# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xtrap/xtrap-1.0.2-r1.ebuild,v 1.8 2013/01/01 18:49:12 armin76 Exp $

EAPI=4
inherit xorg-2

DESCRIPTION="X.Org xtrap application"
KEYWORDS="amd64 arm hppa ~mips ppc ppc64 s390 sh ~sparc x86"
IUSE=""
RDEPEND="x11-libs/libX11
	x11-libs/libXTrap"
DEPEND="${RDEPEND}
	x11-proto/trapproto"
