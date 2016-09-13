# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.4.3
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils flag-o-matic git-r3 python-single-r1

DESCRIPTION="Compiler runtime libraries for clang"
HOMEPAGE="http://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="http://llvm.org/git/compiler-rt.git
	https://github.com/llvm-mirror/compiler-rt.git"

LICENSE="UoI-NCSA"
SLOT="0/${PV%.*}"
KEYWORDS=""
IUSE="+sanitize test"

RDEPEND="
	!<sys-devel/llvm-${PV}
	sanitize? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	~sys-devel/llvm-${PV}
	test? ( ~sys-devel/clang-${PV} )
	${PYTHON_DEPS}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	test? ( sanitize )"

src_unpack() {
	if use test; then
		# needed for patched gtest
		git-r3_fetch "http://llvm.org/git/llvm.git
			https://github.com/llvm-mirror/llvm.git"
	fi
	git-r3_fetch

	if use test; then
		git-r3_checkout http://llvm.org/git/llvm.git \
			"${WORKDIR}"/llvm
	fi
	git-r3_checkout
}

src_prepare() {
	# Support setting LLVM_MAIN_SRC_DIR and other llvm-config overrides
	eapply "${FILESDIR}"/9999/0001-compiler-rt-cmake-Support-overriding-llvm-config-que.patch

	default
}

src_configure() {
	# pre-set since we need to pass it to cmake
	BUILD_DIR=${WORKDIR}/${P}_build

	local clang_version=4.0.0
	local libdir=$(get_libdir)
	local mycmakeargs=(
		# used to find cmake modules
		-DLLVM_LIBDIR_SUFFIX="${libdir#lib}"
		-DCOMPILER_RT_INSTALL_PATH="${EPREFIX}/usr/lib/clang/${clang_version}"
		# use a build dir structure consistent with install
		# this makes it possible to easily deploy test-friendly clang
		-DCOMPILER_RT_OUTPUT_DIR="${BUILD_DIR}/lib/clang/${clang_version}"

		-DCOMPILER_RT_INCLUDE_TESTS=$(usex test)
		-DCOMPILER_RT_BUILD_SANITIZERS=$(usex sanitize)
	)
	if use test; then
		mycmakeargs+=(
			-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"

			# they are created during src_test()
			-DCOMPILER_RT_TEST_COMPILER="${BUILD_DIR}/bin/clang"
			-DCOMPILER_RT_TEST_CXX_COMPILER="${BUILD_DIR}/bin/clang++"
		)

		# same flags are passed for build & tests, so we need to strip
		# them down to a subset supported by clang
		filter-flags -msahf -frecord-gcc-switches
	fi

	cmake-utils_src_configure

	if use test; then
		# copy clang over since resource_dir is located relatively to binary
		# therefore, we can put our new libraries in it
		mkdir -p "${BUILD_DIR}"/{bin,lib/clang/"${clang_version}"/include} || die
		cp "${EPREFIX}/usr/bin/clang" "${EPREFIX}/usr/bin/clang++" \
			"${BUILD_DIR}"/bin/ || die
		cp "${EPREFIX}/usr/lib/clang/${clang_version}/include"/*.h \
			"${BUILD_DIR}/lib/clang/${clang_version}/include/" || die
	fi
}

src_test() {
	# sandbox fiddles with memory error reporting and breaks tests
	local -x SANDBOX_ON=0

	cmake-utils_src_make check-all
}

src_install() {
	cmake-utils_src_install

	use sanitize && python_doscript "${S}"/lib/asan/scripts/asan_symbolize.py
}
