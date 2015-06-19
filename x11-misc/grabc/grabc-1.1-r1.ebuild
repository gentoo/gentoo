# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/grabc/grabc-1.1-r1.ebuild,v 1.6 2012/03/06 21:51:35 ranger Exp $

inherit eutils toolchain-funcs

S="${WORKDIR}/${PN}${PV}"
DESCRIPTION="determine the color string in hex (or RGB components) by clicking on a pixel on the screen"
HOMEPAGE="http://www.muquit.com/muquit/software/grabc/grabc.html"
SRC_URI="http://www.muquit.com/muquit/software/${PN}/${PN}${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-proto/xproto"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_compile() {
	tc-export CC
	emake || die "emake failed"
}

src_install() {
	dobin grabc  || die "dobin failed"
	dodoc README || die "dodoc failed"
}
