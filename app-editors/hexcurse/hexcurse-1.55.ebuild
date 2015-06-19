# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/hexcurse/hexcurse-1.55.ebuild,v 1.17 2015/01/09 16:39:43 jer Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="ncurses based hex editor"
HOMEPAGE="http://www.jewfish.net/description.php?title=HexCurse"
SRC_URI="http://www.jewfish.net/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ppc s390 sh sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND=">=sys-libs/ncurses-5.2"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-gcc.patch \
		"${FILESDIR}"/${PV}-tinfo.patch

	eautoreconf
}

src_install() {
	emake install DESTDIR="${D}" || die "Install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
