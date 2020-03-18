# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools font

DESCRIPTION="An ncurses based app to show a scrolling screen from the Matrix"
HOMEPAGE="https://sourceforge.net/projects/cmatrix/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="X"

DEPEND="
	X? ( >=x11-apps/mkfontscale-1.2.0 )
	sys-libs/ncurses:0="

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-tinfo.patch
)

src_prepare() {
	default

	use X && eapply "${FILESDIR}"/${P}-fontdir.patch

	eautoreconf
}

src_install() {
	dodir /usr/share/consolefonts
	dodir /usr/lib/kbd/consolefonts
	use X && dodir /usr/share/fonts/misc

	default
}

pkg_postinst() {
	if use X; then
		if [[ -d "${ROOT}"usr/share/fonts/misc ]] ; then
			einfo ">>> Running mkfontdir on ${ROOT}usr/share/fonts/misc"
			mkfontdir "${ROOT}"usr/share/fonts/misc
		fi
		font_pkg_postinst
	fi
}

pkg_postrm() {
	use X && font_pkg_postrm
}
