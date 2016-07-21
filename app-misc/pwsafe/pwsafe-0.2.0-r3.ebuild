# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A Password Safe compatible command-line password manager"
HOMEPAGE="http://nsd.dyndns.org/pwsafe/"
SRC_URI="http://nsd.dyndns.org/pwsafe/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="X readline"

DEPEND="sys-libs/ncurses:0=
	dev-libs/openssl:0=
	readline? ( sys-libs/readline:0= )
	X? ( x11-libs/libSM
		x11-libs/libICE
		x11-libs/libXmu
		x11-libs/libX11 )"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply -p0 "${FILESDIR}/${P}-cvs-1.57.patch"
	eapply -p0 "${FILESDIR}/${P}-printf.patch"
	eapply -p0 "${FILESDIR}/${P}-fake-readline.patch"
	eapply -p0 "${FILESDIR}/${P}-man-page-option-syntax.patch"
	eapply -p0 "${FILESDIR}/${P}-XChangeProperty.patch"
	eapply_user
}

src_configure() {
	econf $(use_with X x) $(use_with readline)
}

src_install() {
	doman pwsafe.1
	dobin pwsafe
	dodoc README NEWS
}
