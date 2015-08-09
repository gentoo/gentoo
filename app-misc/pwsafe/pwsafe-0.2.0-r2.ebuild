# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit base eutils

DESCRIPTION="A Password Safe compatible command-line password manager"
HOMEPAGE="http://nsd.dyndns.org/pwsafe/"
SRC_URI="http://nsd.dyndns.org/pwsafe/releases/${P}.tar.gz"
PATCHES=(
			"${FILESDIR}/${P}-cvs-1.57.patch"
			"${FILESDIR}/${P}-printf.patch"
			"${FILESDIR}/${P}-fake-readline.patch"
			"${FILESDIR}/${P}-man-page-option-syntax.patch"
			"${FILESDIR}/${P}-XChangeProperty.patch"
		)

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="X readline"

DEPEND="sys-libs/ncurses
	dev-libs/openssl
	readline? ( sys-libs/readline )
	X? ( x11-libs/libSM
		x11-libs/libICE
		x11-libs/libXmu
		x11-libs/libX11 )"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_with X x) $(use_with readline)
}

src_install() {
	doman pwsafe.1
	dobin pwsafe
	dodoc README NEWS
}
