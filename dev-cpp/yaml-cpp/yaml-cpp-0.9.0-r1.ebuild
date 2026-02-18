# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="YAML parser and emitter in C++"
HOMEPAGE="https://github.com/jbeder/yaml-cpp"
SRC_URI="https://github.com/jbeder/yaml-cpp/archive/refs/tags/${P}.tar.gz"
S="${WORKDIR}/yaml-cpp-${P}"

LICENSE="MIT"
SLOT="0/$(ver_cut 0-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? ( dev-cpp/gtest[${MULTILIB_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}/yaml-cpp-0.9.0-cmakever.patch"
	"${FILESDIR}/yaml-cpp-0.9.0-cxxstd.patch"
	"${FILESDIR}/yaml-cpp-0.9.0-precision.patch"
)

src_prepare() {
	rm -r test/googletest-* || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DYAML_BUILD_SHARED_LIBS=ON
		-DYAML_CPP_BUILD_TOOLS=OFF # Don't have install rule
		-DYAML_CPP_BUILD_TESTS=$(usex test)
		-DYAML_USE_SYSTEM_GTEST=ON
		-DYAML_CPP_FORMAT_SOURCE=OFF
	)

	cmake-multilib_src_configure
}
