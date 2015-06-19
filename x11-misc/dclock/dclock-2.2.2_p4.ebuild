# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/dclock/dclock-2.2.2_p4.ebuild,v 1.8 2014/08/10 20:01:52 slyfox Exp $

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="Digital clock for the X window system"
HOMEPAGE="http://packages.qa.debian.org/d/dclock.html"
SRC_URI="mirror://debian/pool/main/d/${PN}/${PN}_${PV/_p*/}.orig.tar.gz
		mirror://debian/pool/main/d/${PN}/${PN}_${PV/_p/-}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt"
DEPEND="${RDEPEND}
	app-text/rman
	x11-misc/imake"

S=${WORKDIR}/${P/_p*/}

src_prepare() {
	EPATCH_FORCE=yes EPATCH_SUFFIX=diff epatch "${WORKDIR}"/debian/patches
	epatch "${FILESDIR}"/${P}-include.patch
}

src_configure() {
	xmkmf || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" install{,.man}

	insinto /usr/share/sounds
	doins sounds/*

	insinto /usr/share/X11/app-defaults
	newins Dclock.ad DClock

	dodoc README TODO
}
