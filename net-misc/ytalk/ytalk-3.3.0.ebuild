# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ytalk/ytalk-3.3.0.ebuild,v 1.11 2014/10/18 21:18:17 jer Exp $

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
