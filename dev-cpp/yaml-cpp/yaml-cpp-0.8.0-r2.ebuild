# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="YAML parser and emitter in C++"
HOMEPAGE="https://github.com/jbeder/yaml-cpp"
SRC_URI="https://github.com/jbeder/yaml-cpp/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0/0.8"
KEYWORDS="amd64 ~arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? ( dev-cpp/gtest[${MULTILIB_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}/yaml-cpp-0.8.0-gtest.patch"
	"${FILESDIR}/yaml-cpp-0.8.0-gcc13.patch"
	"${FILESDIR}/yaml-cpp-0.8.0-include-cstdint.patch"
	"${FILESDIR}/yaml-cpp-0.8.0-cmake2.patch"
)

src_prepare() {
	rm -r test/gtest-1.11.0 || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DYAML_BUILD_SHARED_LIBS=ON
		-DYAML_CPP_BUILD_TOOLS=OFF # Don't have install rule
		-DYAML_CPP_BUILD_TESTS=$(usex test)
	)

	cmake-multilib_src_configure
}
