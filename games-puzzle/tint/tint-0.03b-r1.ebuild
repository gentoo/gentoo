# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${P/-/_}"
DESCRIPTION="Tint Is Not Tetris, a ncurses based clone of the original Tetris(tm) game"
HOMEPAGE="http://oasis.frogfoot.net/code/tint/"
SRC_URI="http://oasis.frogfoot.net/code/tint/download/${PV}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.4-r1:0="
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-ovflfix.patch )

src_compile() {
	emake \
		STRIP=true \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
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
