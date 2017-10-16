# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

DESCRIPTION="Multi-user replacement for UNIX talk"
HOMEPAGE="http://www.impul.se/ytalk/"
SRC_URI="http://www.impul.se/ytalk/${P}.tar.gz"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	sys-libs/ncurses:0="

DEPEND="
	${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-tinfo.patch )

src_prepare() {
	default
	eautoreconf
}
