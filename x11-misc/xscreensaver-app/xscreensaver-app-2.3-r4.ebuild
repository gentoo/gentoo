# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools toolchain-funcs

MY_PN=${PN/-a/.A}
MY_PN=${MY_PN/xs/XS}
MY_PN=${MY_PN/s/S}

DESCRIPTION="XScreenSaver dockapp for the Window Maker window manager"
HOMEPAGE="http://xscreensaverapp.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/xscreensaverapp/${MY_PN}/${PV}/${MY_PN}-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 x86"

CDEPEND="
	x11-libs/libdockapp
	x11-libs/libX11
"
DEPEND="
	${CDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
"
RDEPEND="
	${CDEPEND}
	x11-misc/xscreensaver
"

S=${WORKDIR}/${MY_PN}-${PV}

src_prepare() {
	rm configure.in || die
	cp "${FILESDIR}"/${PN}-2.3-configure.ac configure.ac || die

	default

	eautoreconf
}

src_install() {
	dobin ${MY_PN}
	dodoc README NEWS ChangeLog TODO AUTHORS
}
