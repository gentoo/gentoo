# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR=emake

inherit cmake

DESCRIPTION="Family of header-only, fast and memory-friendly hashmap and btree containers"
HOMEPAGE="
	https://greg7mdp.github.io/parallel-hashmap/
	https://github.com/greg7mdp/parallel-hashmap
"
SRC_URI="https://github.com/greg7mdp/parallel-hashmap/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64"
IUSE="examples test"

CDEPEND="dev-libs/cereal"
DEPEND="
	${CDEPEND}
	test? ( dev-cpp/gtest )
"
RDEPEND="${CDEPEND}"

# tests will download gtest, not trivial to use the system one
# https://github.com/greg7mdp/parallel-hashmap/issues/154
RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DPHMAP_BUILD_EXAMPLES=$(usex examples)
		-DPHMAP_BUILD_TESTS=$(usex test)
	)
	if use test; then
		mycmakeargs+=( -DPHMAP_GTEST_LIBS="gmock -lgmock_main -lgtest -lgtest_main" )
	fi
	cmake_src_configure
}

src_install() {
	cmake_src_install
	if use examples ; then
		dodoc -r examples
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
}
