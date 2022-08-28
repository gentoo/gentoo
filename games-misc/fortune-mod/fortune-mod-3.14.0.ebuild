# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="The notorious fortune program"
HOMEPAGE="https://www.shlomifish.org/open-source/projects/fortune-mod/ http://www.redellipse.net/code/fortune"
SRC_URI="https://www.shlomifish.org/open-source/projects/${PN}/arcs/${P}.tar.xz
	https://github.com/shlomif/fortune-mod/releases/download/${P}/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~riscv ~sparc ~x86"
IUSE="offensive test"
RESTRICT="!test? ( test )"

RDEPEND="app-text/recode:=
	!games-misc/fortune-mod-tao"
DEPEND="${RDEPEND}"
BDEPEND="app-text/App-XML-DocBook-Builder
	test? (
		dev-perl/File-Find-Object
		dev-perl/IO-All
		dev-perl/Test-Differences
		dev-perl/Test-Trap
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-3.14.0-valgrind-tests.patch
)

src_configure() {
	local mycmakeargs=(
		-DNO_OFFENSIVE=$(usex !offensive)
		-DLOCALDIR="/usr/share/fortune"
		-DCOOKIEDIR="/usr/share/fortune"
	)

	cmake_src_configure
}

src_test() {
	cmake_src_compile check
}

src_install() {
	cmake_src_install

	mkdir -p "${ED}"/usr/bin || die
	mv "${ED}"/usr/games/fortune "${ED}"/usr/bin/fortune || die
	rm -rf "${ED}"/usr/games || die

	dodoc ChangeLog INDEX Notes Offensive README TODO cookie-files
}
