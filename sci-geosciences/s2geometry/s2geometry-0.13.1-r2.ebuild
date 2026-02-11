# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Computational geometry and spatial indexing on the sphere"
HOMEPAGE="http://s2geometry.io/"
SRC_URI="https://github.com/google/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-cpp/abseil-cpp-20250814.1:=
	dev-libs/openssl:=
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-test.patch )

src_configure() {
	append-cxxflags $(usex debug '-DDEBUG' '-DNDEBUG')

	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
	)
	if use test; then
		mycmakeargs += -DGOOGLETEST_ROOT=/usr/include
	fi
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rm -f "${D}"/usr/$(get_libdir)/libs2testing.a \
		|| die
}
