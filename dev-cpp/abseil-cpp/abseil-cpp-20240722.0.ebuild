# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit cmake-multilib python-any-r1

DESCRIPTION="Abseil Common Libraries (C++), LTS Branch"
HOMEPAGE="https://abseil.io/"
SRC_URI="https://github.com/abseil/abseil-cpp/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/${PV:2:4}.$(ver_cut 2).0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ~mips ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos"
IUSE="test"

RDEPEND=">=dev-cpp/gtest-1.13.0[${MULTILIB_USEDEP}]"
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
	# "${FILESDIR}/${PN}-random-tests.patch" #935417
	# "${FILESDIR}/${PN}-20230802.0-conditional-use-of-lzcnt.patch" #934337
	"${FILESDIR}/${PN}-include-cstdint.patch" #937307
	"${FILESDIR}/${PN}-20240722.0-lto-odr.patch"
)

src_prepare() {
	cmake_src_prepare

	use ppc && eapply "${FILESDIR}/${PN}-atomic.patch"

	# un-hardcode abseil compiler flags
	sed -i \
		-e '/"-maes",/d' \
		-e '/"-msse4.1",/d' \
		-e '/"-mfpu=neon"/d' \
		-e '/"-march=armv8-a+crypto"/d' \
		absl/copts/copts.py || die

	# now generate cmake files
	python_fix_shebang absl/copts/generate_copts.py
	absl/copts/generate_copts.py || die
}

multilib_src_configure() {
	local mycmakeargs=(
		-DABSL_ENABLE_INSTALL=TRUE
		-DABSL_USE_EXTERNAL_GOOGLETEST=ON
		-DABSL_PROPAGATE_CXX_STD=TRUE
		# TEST_HELPERS needed for protobuf (bug #915902)
		-DABSL_BUILD_TEST_HELPERS=ON
		-DABSL_BUILD_TESTING="$(usex test)"
	)
	# intentional use, it uses both variables for tests.
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
