# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Rapid fuzzy string matching in C++"
HOMEPAGE="https://github.com/maxbachmann/rapidfuzz-cpp/"
SRC_URI="
	https://github.com/maxbachmann/rapidfuzz-cpp/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		>=dev-cpp/catch-3
	)
"

src_prepare() {
	# apparently "C++ best practices" don't mind fetching random stuff
	# at build time
	sed -i -e '/aminya/,/^)/d' test/CMakeLists.txt || die
	find -name 'CMakeLists.txt' -exec \
		sed -i -e 's:project_warnings::' {} + || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DRAPIDFUZZ_BUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
