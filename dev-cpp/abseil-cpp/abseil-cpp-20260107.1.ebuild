# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )

inherit cmake-multilib edo flag-o-matic python-any-r1

DESCRIPTION="Abseil Common Libraries (C++), LTS Branch"
HOMEPAGE="https://abseil.io/"
SRC_URI="
	https://github.com/abseil/abseil-cpp/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/abseil/abseil-cpp/commit/28e6a799ba550f8d499bfda5e100d16937804f72.patch
		-> ${PN}-20260107.0-c++23.patch
"

LICENSE="Apache-2.0"

# ABI, we want rebuilds to avoid hidden breakage
SLOT="0/${PV:2:4}.$(ver_cut 2).0-cpp20"
# SONAME
# SLOT="0/${PV:2:4}.0.0-cpp20"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos"
IUSE="debug test test-helpers"

RDEPEND="
	test? (
		dev-cpp/gtest:=[${MULTILIB_USEDEP}]
	)
	test-helpers? (
		dev-cpp/gtest:=[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	test? (
		sys-libs/timezone-data
	)
"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${PN}-20230802.0-sdata-tests.patch"
	"${FILESDIR}/${PN}-20240722.0-lto-odr.patch"
	# https://github.com/abseil/abseil-cpp/issues/1992
	"${DISTDIR}/${PN}-20260107.0-c++23.patch"
)

src_prepare() {
	cmake_src_prepare

	use ppc && eapply "${FILESDIR}/${PN}-atomic.patch"

	# un-hardcode abseil compiler flags
	# 942192
	sed -i \
		-e '/NOMINMAX/d' \
		absl/copts/copts.py || die

	# now generate cmake files
	python_fix_shebang absl/copts/generate_copts.py
	edo absl/copts/generate_copts.py
}

multilib_src_configure() {
	append-cxxflags "$(usex debug '-DDEBUG' '-DNDEBUG')"

	if [[ ${ABI} == x86 ]]; then
		# error: ‘_mm_cvtsi128_si64’ was not declared in this scope
		# maybe fixed in 4bd9ee20
		local _CXXFLAGS="${CXXFLAGS}"
		local CXXFLAGS="${_CXXFLAGS} -mno-aes"
	fi

	local mycmakeargs=(
		-DCMAKE_CXX_STANDARD=20
		-DABSL_ENABLE_INSTALL="yes"
		-DABSL_USE_EXTERNAL_GOOGLETEST="yes"
		-DABSL_PROPAGATE_CXX_STD="yes"

		# TEST_HELPERS needed for protobuf (bug #915902)
		-DABSL_BUILD_TEST_HELPERS="$(usex test-helpers)"

		-DABSL_BUILD_TESTING="$(usex test)"
	)
	# intentional use, it requires both variables for tests.
	# (BUILD_TESTING AND ABSL_BUILD_TESTING)
	if use test; then
		mycmakeargs+=(
			-DBUILD_TESTING="yes"
		)
	fi

	cmake_src_configure
}

multilib_src_test() {
	if ! use amd64; then
		CMAKE_SKIP_TESTS=(
			absl_symbolize_test
		)

		if use ppc; then
			CMAKE_SKIP_TESTS+=(
				absl_failure_signal_handler_test
			)
		fi
	else
		if ! multilib_is_native_abi; then
			CMAKE_SKIP_TESTS+=(
				absl_hash_instantiated_test
			)
		fi
	fi

	cmake_src_test
}
