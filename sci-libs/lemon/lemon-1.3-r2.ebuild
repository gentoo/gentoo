# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils

DESCRIPTION="C++ template static library of common data structures and algorithms"
HOMEPAGE="https://lemon.cs.elte.hu/trac/lemon/"
SRC_URI="https://lemon.cs.elte.hu/pub/sources/${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+coin doc glpk static-libs test tools"

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

REQUIRED_USE="|| ( coin glpk )"

PATCHES=(
	"${FILESDIR}"/${P}-multilib.patch
	"${FILESDIR}"/${P}-as-needed.patch
)

src_prepare() {
	sed -i \
		-e '/ADD_SUBDIRECTORY(demo)/d' \
		CMakeLists.txt || die

	use doc || sed -i \
		-e '/ADD_SUBDIRECTORY(doc)/d' \
		CMakeLists.txt || die

	use tools || sed -i \
		-e '/ADD_SUBDIRECTORY(tools)/d' \
		CMakeLists.txt || die

	use test || sed -i \
		-e '/ADD_SUBDIRECTORY(test)/d' \
		CMakeLists.txt || die

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
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=TRUE
		-DCOIN_ROOT_DIR="${EPREFIX}/usr"
		-DLEMON_DOC_MATHJAX_RELPATH="${EPREFIX}/usr/share/mathjax"
		$(cmake-utils_use doc LEMON_DOC_SOURCE_BROWSER)
		$(cmake-utils_use doc LEMON_DOC_USE_MATHJAX)
		$(cmake-utils_use coin LEMON_ENABLE_COIN)
		$(cmake-utils_use glpk LEMON_ENABLE_GLPK)
	)
	cmake-utils_src_configure
}

src_test() {
	emake -C "${BUILD_DIR}" check
}
