# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="The notorious fortune program"
HOMEPAGE="https://www.shlomifish.org/open-source/projects/fortune-mod/ http://www.redellipse.net/code/fortune"
SRC_URI="https://github.com/shlomif/fortune-mod/releases/download/${P}/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~riscv ~x86"
IUSE="offensive"

DEPEND="app-text/recode:=
	!games-misc/fortune-mod-tao"
RDEPEND="${DEPEND}"
BDEPEND="app-text/App-XML-DocBook-Builder"

# TODO: Get tests running?

src_configure() {
	local mycmakeargs=(
		-DNO_OFFENSIVE=$(usex !offensive)
		-DLOCALDIR="/usr/share/fortune"
		-DCOOKIEDIR="/usr/share/fortune"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	mkdir -p "${ED}"/usr/bin || die
	mv "${ED}"/usr/games/fortune "${ED}"/usr/bin/fortune || die
	rm -rf "${ED}"/usr/games || die

	dodoc ChangeLog INDEX Notes Offensive README TODO cookie-files
}
