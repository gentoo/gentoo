# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="Multi-user replacement for UNIX talk"
HOMEPAGE="http://www.impul.se/ytalk/"
SRC_URI="http://www.impul.se/ytalk/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ~ia64 ppc ~ppc64 sparc x86"

RDEPEND=">=sys-libs/ncurses-5.2"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=( ChangeLog INSTALL README )

src_prepare() {
	epatch "${FILESDIR}"/${P}-tinfo.patch
	eautoreconf
}
