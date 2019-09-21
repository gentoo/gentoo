# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit eutils

IUSE=""

MY_P=${P/_beta/-beta}
S=${WORKDIR}/${PN}

DESCRIPTION="CD player applet for WindowMaker"
SRC_URI="https://www.dockapps.net/download/${MY_P}.tgz"
HOMEPAGE="https://www.dockapps.net/wmcdplay"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-misc/imake"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~ppc x86"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-xpmdir.patch
	epatch "${FILESDIR}"/${PN}-ComplexProgramTargetNoMan.patch
	epatch "${FILESDIR}"/${PN}-c++.patch
}

src_compile() {
	xmkmf || die "xmkmf failed."
	emake CDEBUGFLAGS="${CFLAGS}" LDOPTIONS="${LDFLAGS}" || die "emake failed."
}

src_install() {
	einstall DESTDIR="${D}" BINDIR="/usr/bin" || die "emake install failed."

	insinto /usr/share/WMcdplay
	doins XPM/*.art

	dodoc ARTWORK README

	domenu "${FILESDIR}"/${PN}.desktop
}
