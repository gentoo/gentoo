# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Needed to build tests for now
CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake

DESCRIPTION="C++ template static library of common data structures and algorithms"
HOMEPAGE="https://lemon.cs.elte.hu/trac/lemon/"
SRC_URI="https://lemon.cs.elte.hu/pub/sources/${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+coin doc glpk static-libs test"

REQUIRED_USE="|| ( coin glpk )"
RESTRICT="!test? ( test )"

RDEPEND="
	coin? (
		sci-libs/coinor-cbc:=
		sci-libs/coinor-clp:=
	)
	glpk? ( sci-mathematics/glpk:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		app-text/doxygen
		app-text/ghostscript-gpl
		<dev-libs/mathjax-3
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-multilib.patch
	"${FILESDIR}"/${PN}-1.3-as-needed.patch
	"${FILESDIR}"/${P}-cmake4.patch # bug 967729
	"${FILESDIR}"/${P}-disable-broken-tests.patch
)

src_prepare() {
	cmake_comment_add_subdirectory demo

	use doc || cmake_comment_add_subdirectory doc
	use test || cmake_comment_add_subdirectory test

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLEMON_ENABLE_COIN=$(usex coin)
		-DLEMON_ENABLE_GLPK=$(usex glpk)
	)

	use coin && mycmakeargs+=( -DCOIN_ROOT_DIR="${EPREFIX}/usr" )

	if use doc; then
		mycmakeargs+=(
			-DLEMON_DOC_MATHJAX_RELPATH="${EPREFIX}/usr/share/mathjax"
			-DLEMON_DOC_SOURCE_BROWSER=$(usex doc)
			-DLEMON_DOC_USE_MATHJAX=$(usex doc)
		)
	fi

	cmake_src_configure
}

src_test() {
	pushd "${S}" > /dev/null || die
		emake -C "${BUILD_DIR}" check
	popd > /dev/null || die
}

src_install() {
	cmake_src_install

	# TODO: Upstream needs to see the light of GNUInstallDirs
	if use doc; then
		mv "${ED}"/usr/share/doc/lemon/html "${ED}"/usr/share/doc/${PF} || die
		rmdir "${ED}"/usr/share/doc/lemon || die
	fi
}
