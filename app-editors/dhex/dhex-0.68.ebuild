# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/dhex/dhex-0.68.ebuild,v 1.4 2014/03/20 04:15:35 mattst88 Exp $

EAPI=4

inherit eutils toolchain-funcs

MY_P=${PN}_${PV}

DESCRIPTION="ncurses-based hex-editor with diff mode"
HOMEPAGE="http://www.dettus.net/dhex/"
SRC_URI="http://www.dettus.net/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips x86"
IUSE=""

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.63-Makefile.patch
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin dhex
	dodoc README.txt
	doman dhex.1 dhex_markers.5 dhex_searchlog.5 dhexrc.5
}
