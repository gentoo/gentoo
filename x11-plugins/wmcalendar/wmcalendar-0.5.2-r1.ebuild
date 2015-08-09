# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="a calendar dockapp"
HOMEPAGE="http://wmcalendar.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc sparc x86"
IUSE=""

RDEPEND="
	dev-libs/libical
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=( ../{BUGS,CHANGES,HINTS,README,TODO} )

S=${WORKDIR}/${P}/Src

src_prepare() {
	epatch "${FILESDIR}"/${P}-exit-sin-and-cos.patch
	epatch "${FILESDIR}"/${P}-rename_kill_func.patch
	epatch "${FILESDIR}"/${P}-ical.patch
	tc-export CC PKG_CONFIG
}
