# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A curses-based ascii-art editor"
HOMEPAGE="http://aewan.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DOCS=( CHANGELOG README TODO )

DEPEND="sys-libs/zlib
	>=sys-libs/ncurses-5.0:0="

RDEPEND="${DEPEND}"

src_prepare() {
	default
	eapply \
		"${FILESDIR}/${P}-debug_aewl-warnings.patch" \
		"${FILESDIR}/${P}-tinfo.patch"
	eautoreconf
}
