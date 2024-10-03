# Copyright 2012-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

# Different date format used upstream.
RE2_VER=${PV#0.}
RE2_VER=${RE2_VER//./-}

DESCRIPTION="An efficient, principled regular expression library"
HOMEPAGE="https://github.com/google/re2"
SRC_URI="https://github.com/google/re2/archive/${RE2_VER}.tar.gz -> re2-${RE2_VER}.tar.gz"
S="${WORKDIR}/re2-${RE2_VER}"

LICENSE="BSD"
# NOTE: Always run libre2 through abi-compliance-checker!
# https://abi-laboratory.pro/tracker/timeline/re2/
SONAME="11"
SLOT="0/${SONAME}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~sparc ~x86"
IUSE="benchmark icu test test-full"
REQUIRED_USE="
	test? ( benchmark )
	test-full? ( test )"

RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-cpp/gtest[${MULTILIB_USEDEP}] )"
RDEPEND="
	>=dev-cpp/abseil-cpp-20240116.2-r3:=[${MULTILIB_USEDEP}]
	benchmark? ( dev-cpp/benchmark[${MULTILIB_USEDEP}] )
	icu? ( dev-libs/icu:0=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

DOCS=( README doc/syntax.txt )
HTML_DOCS=( doc/syntax.html )

PATCHES=( "${FILESDIR}/re2-build-static-libtesting.patch" )

src_configure() {
	local mycmakeargs=(
		-DRE2_USE_ICU=$(usex icu)
	)
	if use test || use benchmark; then
		mycmakeargs+=( -DRE2_BUILD_TESTING=YES )
	else
		mycmakeargs+=( -DRE2_BUILD_TESTING=NO )
	fi

	cmake-multilib_src_configure
}

src_test() {
	use test-full || local CMAKE_SKIP_TESTS=( '.*(exhaustive|dfa|random).*' )

	cmake-multilib_src_test
}

multilib_src_install() {
	cmake_src_install

	if multilib_is_native_abi && use benchmark; then
		newbin regexp_benchmark re2-bench
	fi
}
