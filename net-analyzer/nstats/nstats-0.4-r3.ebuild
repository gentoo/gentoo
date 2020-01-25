# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Displays statistics about ethernet traffic including protocol breakdown"
SRC_URI="http://trash.net/~reeler/nstats/files/${P}.tar.gz"
HOMEPAGE="http://trash.net/~reeler/nstats/"
LICENSE="Artistic"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	net-libs/libpcap
	sys-libs/ncurses
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${P}-glibc24.patch
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-tinfo.patch
)
DOCS=( BUGS doc/TODO doc/ChangeLog )

src_prepare(){
	default

	eautoreconf
}
