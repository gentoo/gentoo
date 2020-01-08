# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Interactive console program to analyse squid logs"
HOMEPAGE="http://www.rillion.net/squidview/"
SRC_URI="http://www.rillion.net/squidview/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	sys-libs/ncurses
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
DOCS=(
	AUTHORS BUGS ChangeLog HOWTO README
)
PATCHES=(
	"${FILESDIR}"/${PN}-0.86-tinfo.patch
)

src_prepare() {
	default
	eautoreconf
}
