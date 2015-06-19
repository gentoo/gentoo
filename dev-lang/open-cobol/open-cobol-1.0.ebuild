# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/open-cobol/open-cobol-1.0.ebuild,v 1.3 2008/09/06 11:33:17 pchrist Exp $

inherit eutils

DESCRIPTION="an open-source COBOL compiler"
HOMEPAGE="http://www.opencobol.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="berkdb nls readline"

RDEPEND="dev-libs/gmp
	berkdb? ( =sys-libs/db-4* )
	sys-libs/ncurses
	readline? ( sys-libs/readline )"
DEPEND="${RDEPEND}
	sys-devel/libtool"

src_compile() {
	econf \
		$(use_with berkdb db) \
		$(use_enable nls) \
		$(use_with readline) || die "econf failed."
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README
}
