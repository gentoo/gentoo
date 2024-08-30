# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="The notorious fortune program"
HOMEPAGE="https://www.shlomifish.org/open-source/projects/fortune-mod/"
SRC_URI="
	https://www.shlomifish.org/open-source/projects/${PN}/arcs/${P}.tar.xz
	https://github.com/shlomif/fortune-mod/releases/download/${P}/${P}.tar.xz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~riscv ~sparc ~x86"
IUSE="offensive pcre test"
RESTRICT="!test? ( test )"

RDEPEND="
	!games-misc/fortune-mod-tao
	app-text/recode:=
	>=dev-libs/rinutils-0.10.2
	pcre? ( dev-libs/libpcre2 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/App-XML-DocBook-Builder
	dev-lang/perl
	test? (
		dev-perl/File-Find-Object
		dev-perl/IO-All
		dev-perl/Test-Differences
		dev-perl/Test-Trap
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.14.0-valgrind-tests.patch
)

src_configure() {
	local mycmakeargs=(
		-DUSE_PCRE=$(usex pcre)
		-DNO_OFFENSIVE=$(usex !offensive)
		# bug #857246
		-DLOCALDIR="/usr/local/share/fortune"
		-DCOOKIEDIR="/usr/share/fortune"
	)

	cmake_src_configure
}

src_test() {
	cmake_src_compile check
}

src_install() {
	cmake_src_install

	# We don't want to create the dir if it doesn't exist
	rm -rf "${ED}"//usr/local || die

	mkdir -p "${ED}"/usr/bin || die
	mv "${ED}"/usr/games/fortune "${ED}"/usr/bin/fortune || die
	rm -rf "${ED}"/usr/games || die

	dodoc ChangeLog INDEX Notes Offensive README TODO cookie-files
}
