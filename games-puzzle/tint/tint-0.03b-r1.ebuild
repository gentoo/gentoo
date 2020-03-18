# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${P/-/_}"
DESCRIPTION="Tint Is Not Tetris, a ncurses based clone of the original Tetris(tm) game"
HOMEPAGE="http://oasis.frogfoot.net/code/tint/"
SRC_URI="http://oasis.frogfoot.net/code/tint/download/${PV}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.4-r1:0="
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-ovflfix.patch )

src_compile() {
	local PKGCONFIG="$(tc-getPKG_CONFIG)"
	emake \
		STRIP=true \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		LDLIBS="$(${PKGCONFIG} --libs ncurses)" \
		localstatedir="/var/lib"
}

src_install() {
	dobin tint
	doman tint.6
	dodoc CREDITS NOTES
	insopts -m 0664
	insinto /var/lib
	doins tint.scores
}
