# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake font

DESCRIPTION="An ncurses based app to show a scrolling screen from the Matrix"
HOMEPAGE="
	https://www.asty.org/cmatrix/
	https://github.com/abishekvashok/cmatrix
"
SRC_URI="https://github.com/abishekvashok/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ppc ppc64 sparc x86"
IUSE="X +unicode"

DEPEND="
	sys-libs/ncurses:0=[unicode?]
"
BDEPEND="
	X? ( >=x11-apps/mkfontscale-1.2.0 )
"
RDEPEND="
	${DEPEND}
"

src_configure() {
	mycmakeargs=(
		-DCURSES_NEED_WIDE=$(usex unicode)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	font_src_install
	doman ${PN}.1
}

pkg_postinst() {
	if use X; then
		if [[ -d "${ROOT}"/usr/share/fonts/misc ]] ; then
			einfo ">>> Running mkfontdir on ${ROOT}/usr/share/fonts/misc"
			mkfontdir "${ROOT}"/usr/share/fonts/misc
		fi
		font_pkg_postinst
	fi
}

pkg_postrm() {
	use X && font_pkg_postrm
}
