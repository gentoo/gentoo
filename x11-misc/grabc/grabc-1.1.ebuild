# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/grabc/grabc-1.1.ebuild,v 1.11 2010/07/21 14:27:56 ssuominen Exp $

S="${WORKDIR}/${PN}${PV}"
DESCRIPTION="determine the color string in hex (or RGB components) by clicking on a pixel on the screen"
HOMEPAGE="http://www.muquit.com/muquit/software/grabc/grabc.html"
SRC_URI="http://www.muquit.com/muquit/software/${PN}/${PN}${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ppc64 amd64"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-proto/xproto
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e "s/-O/${CFLAGS}/" Makefile || \
			die "sed Makefile failed"
}

src_install() {
	dobin grabc  || die "dobin failed"
	dodoc README || die "dodoc failed"
}
