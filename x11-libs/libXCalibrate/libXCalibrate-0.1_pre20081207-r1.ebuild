# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXCalibrate/libXCalibrate-0.1_pre20081207-r1.ebuild,v 1.11 2012/05/05 03:52:30 jdhore Exp $

EAPI=4

XORG_EAUTORECONF=yes

inherit xorg-2

MY_PV=${PV#*_pre}

DESCRIPTION="X.Org Calibrate client-side protocol library"
SRC_URI="mirror://gentoo/${PN}-${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-proto/xcalibrateproto
	x11-proto/xextproto"

S=${WORKDIR}/${PN}
