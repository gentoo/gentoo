# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit cmake-multilib python-any-r1

DESCRIPTION="Abseil Common Libraries (C++), LTS Branch"
HOMEPAGE="https://abseil.io/"
SRC_URI="https://github.com/abseil/abseil-cpp/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV:2:4}.$(ver_cut 2).0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos"
IUSE="test test-helpers"

RDEPEND="
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
	"${FILESDIR}/${PN}-random-tests.patch" #935417
	"${FILESDIR}/${PN}-20230802.0-conditional-use-of-lzcnt.patch" #934337
	"${FILESDIR}/${PN}-include-cstdint.patch" #937307
	"${FILESDIR}/${PN}-20240722.0-ciso646-cxx17.patch"
)

src_prepare() {
	cmake_src_prepare

	use ppc && eapply "${FILESDIR}/${PN}-atomic.patch"

	# un-hardcode abseil compiler flags
	# 942192
	sed -i \
		-e '/"-maes",/d' \
		-e '/"-msse4.1",/d' \
		-e '/"-mfpu=neon"/d' \
		-e '/"-march=armv8-a+crypto"/d' \
		-e '/NOMINMAX/d' \
		absl/copts/copts.py || die

	# now generate cmake files
	python_fix_shebang absl/copts/generate_copts.py
	absl/copts/generate_copts.py || die
}

multilib_src_configure() {
	local mycmakeargs=(
		# We use -std=c++14 here so that abseil-cpp's string_view is used
		# See the discussion in https://github.com/gentoo/gentoo/pull/32281.
		-DCMAKE_CXX_STANDARD=14

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
	fi

	cmake_src_test
}
