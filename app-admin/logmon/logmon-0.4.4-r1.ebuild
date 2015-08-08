# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils autotools

MY_P="LogMon-${PV}"
DESCRIPTION="Split-screen terminal/ncurses based log viewer"
HOMEPAGE="http://www.edespot.com/code/LogMon/"
SRC_URI="http://www.edespot.com/code/LogMon/${MY_P}.tar.bz2"

S="${WORKDIR}/${MY_P}"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"

src_prepare() {
	# Bug 119403 - should be in upstream next release
	epatch "${FILESDIR}"/${P}-char2int.diff

	# Bug 250602, gcc43 fix
	epatch "${FILESDIR}"/${P}-gcc43.patch

	# Fixes maintainer-mode detected.
	epatch "${FILESDIR}"/${P}-maintainer-mode.patch

	epatch "${FILESDIR}"/${P}-tinfo.patch

	eautoreconf
}

src_install() {
	dobin logmon

	dodoc AUTHORS ChangeLog README TODO
}
