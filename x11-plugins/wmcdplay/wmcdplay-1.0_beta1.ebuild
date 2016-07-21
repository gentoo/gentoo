# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

IUSE=""

MY_P=${P/_beta/-beta}
S=${WORKDIR}/${PN}

DESCRIPTION="CD player applet for WindowMaker"
SRC_URI="mirror://gentoo/${MY_P}.tgz"
HOMEPAGE="https://www.gentoo.org/"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto
	x11-misc/imake"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"

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
