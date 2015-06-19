# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/rhapsody/rhapsody-0.28b.ebuild,v 1.5 2009/12/15 19:16:19 armin76 Exp $

inherit toolchain-funcs eutils

DESCRIPTION="IRC client intended to be displayed on a text console"
HOMEPAGE="http://rhapsody.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.0"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-uclibc.patch
}

src_compile() {
	./configure -i /usr/share/rhapsody || die "configure failed"
	emake CC="$(tc-getCC)" LOCALFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dobin rhapsody || die "dobin failed"

	insinto /usr/share/rhapsody/help
	doins help/*.hlp || die "doins failed"

	dodoc docs/CHANGELOG || die "dodoc failed"
}
