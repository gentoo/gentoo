# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONT_SUFFIX="pcf"

inherit cmake font

DESCRIPTION="An ncurses based app to show a scrolling screen from the Matrix"
HOMEPAGE="
	https://www.asty.org/cmatrix/
	https://github.com/abishekvashok/cmatrix
"
SRC_URI="https://github.com/abishekvashok/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc ppc64 sparc x86"
IUSE="+unicode"

DEPEND="sys-libs/ncurses:=[unicode(+)?]"
BDEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs=(
		-DCURSES_NEED_WIDE=$(usex unicode)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	use X && font_src_install
	doman ${PN}.1
}

pkg_postinst() {
	use X && font_pkg_postinst
}

pkg_postrm() {
	use X && font_pkg_postrm
}
