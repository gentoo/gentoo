# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xvidtune/xvidtune-1.0.2-r1.ebuild,v 1.8 2012/08/26 17:07:41 armin76 Exp $

EAPI=4
inherit xorg-2

DESCRIPTION="video mode tuner for Xorg"

KEYWORDS="alpha amd64 arm hppa ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND="x11-libs/libXaw
	x11-libs/libXmu
	x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXxf86vm"
DEPEND="${RDEPEND}
	x11-proto/xf86vidmodeproto"
