# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit cmake multiprocessing python-any-r1

DESCRIPTION="Build EAR generates a compilation database for clang tooling"
HOMEPAGE="https://github.com/rizsotto/Bear"
SRC_URI="https://github.com/rizsotto/Bear/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P^}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/abseil-cpp:=
	>=dev-cpp/nlohmann_json-3.11.2:=
	>=dev-libs/libfmt-9.1.0:=
	dev-libs/protobuf:=
	>=dev-libs/spdlog-1.11.0:=
	>=net-libs/grpc-1.49.2:=
"

DEPEND="
	${RDEPEND}
	test? (
		>=dev-cpp/gtest-1.13
	)
"

BDEPEND="
	virtual/pkgconfig
	test? (
		dev-build/libtool
		$(python_gen_any_dep '
			dev-python/lit[${PYTHON_USEDEP}]
		')
	)
"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	# Turn off testing before installation
	sed -i 's/TEST_BEFORE_INSTALL/TEST_EXCLUDE_FROM_MAIN/g' CMakeLists.txt || die
}

src_configure() {
	# TODO: remove this when https://bugs.gentoo.org/928346 is fixed
	export CMAKE_BUILD_PARALLEL_LEVEL=$(makeopts_jobs)

	local mycmakeargs=(
		-DENABLE_UNIT_TESTS="$(usex test)"
		-DENABLE_FUNC_TESTS="$(usex test)"
	)
	cmake_src_configure
}

src_test() {
	if has sandbox ${FEATURES}; then
		ewarn "\'FEATURES=sandbox\' detected"
		ewarn "Bear overrides LD_PRELOAD and conflicts with gentoo sandbox"
		ewarn "Skipping tests"
	elif
		has usersandbox ${FEATURES}; then
		ewarn "\'FEATURES=usersandbox\' detected"
		ewarn "Skipping tests"
	elif
		has network-sandbox ${FEATURES}; then
		ewarn "\'FEATURES=network-sandbox\' detected"
		ewarn "Skipping tests"
	elif
		has_version -b 'sys-devel/gcc-config[-native-symlinks]'; then
		ewarn "\'sys-devel/gcc-config[-native-symlinks]\' detected, tests call /usr/bin/cc directly (hardcoded)"
		ewarn "and will fail without generic cc symlink"
		ewarn "Skipping tests"
	else
		einfo "test may use optional tools if found: qmake gfortran valgrind"
		# unit tests
		cmake_run_in "${BUILD_DIR}/subprojects/Build/BearSource" ctest --verbose
		# functional tests
		cmake_run_in "${BUILD_DIR}/subprojects/Build/BearTest" ctest --verbose
	fi
}
