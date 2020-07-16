# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="C++ template static library of common data structures and algorithms"
HOMEPAGE="https://lemon.cs.elte.hu/trac/lemon/"
SRC_URI="https://lemon.cs.elte.hu/pub/sources/${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+coin doc glpk static-libs test"
RESTRICT="!test? ( test )"

REQUIRED_USE="|| ( coin glpk )"

RDEPEND="
	coin? (
		sci-libs/coinor-cbc:=
		sci-libs/coinor-clp:=
	)
	glpk? ( sci-mathematics/glpk:= )
"
DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen
		app-text/ghostscript-gpl
		dev-libs/mathjax
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-multilib.patch
	"${FILESDIR}"/${PN}-1.3-as-needed.patch
)

src_prepare() {
	cmake-utils_src_prepare
	cmake_comment_add_subdirectory demo

	use doc || cmake_comment_add_subdirectory doc
	use test || cmake_comment_add_subdirectory test

	for t in \
		max_clique \
		max_flow \
		graph_utils \
		random \
		time_measure \
		tsp; do
		sed -i -e "/${t}_test/d" test/CMakeLists.txt || die
	done
	sed -i \
		-e '/ADD_TEST(lp_test lp_test)/d' \
		-e '/ADD_DEPENDENCIES(check lp_test)/d' \
		test/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=TRUE
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
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	# TODO: Upstream needs to see the light of GNUInstallDirs
	if use doc; then
		mv "${D}"/usr/share/doc/lemon/html "${D}"/usr/share/doc/${PF} || die
		rmdir "${D}"/usr/share/doc/lemon || die
	fi
}

src_test() {
	emake -C "${BUILD_DIR}" check
}
