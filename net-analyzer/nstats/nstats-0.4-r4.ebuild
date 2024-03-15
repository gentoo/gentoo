# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Displays statistics about ethernet traffic including protocol breakdown"
HOMEPAGE="http://trash.net/~reeler/nstats/"
SRC_URI="http://trash.net/~reeler/nstats/files/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="
	net-libs/libpcap
	sys-libs/ncurses
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-glibc24.patch
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-tinfo.patch
)

DOCS=( BUGS doc/TODO doc/ChangeLog )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cflags -fcommon
	# Conflicting definitions of quit() (bug #861227)
	filter-lto
	default
}
