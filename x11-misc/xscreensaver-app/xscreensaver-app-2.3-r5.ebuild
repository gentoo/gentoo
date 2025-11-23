# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools

MY_PN=${PN/-a/.A}
MY_PN=${MY_PN/xs/XS}
MY_PN=${MY_PN/s/S}

DESCRIPTION="XScreenSaver dockapp for the Window Maker window manager"
HOMEPAGE="https://xscreensaverapp.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/xscreensaverapp/${MY_PN}/${PV}/${MY_PN}-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"

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

PATCHES=(
	"${FILESDIR}/${PN}-2.3-gcc14-build-fix.patch"
)

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
