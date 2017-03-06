# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils llvm python-any-r1

DESCRIPTION="The LLVM linker (link editor)"
HOMEPAGE="http://llvm.org/"
SRC_URI="http://www.llvm.org/pre-releases/${PV/_//}/${P/_/}.src.tar.xz
	test? ( http://www.llvm.org/pre-releases/${PV/_//}/llvm-${PV/_/}.src.tar.xz )"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"

RDEPEND="~sys-devel/llvm-${PV}"
DEPEND="${RDEPEND}
	test? ( $(python_gen_any_dep "~dev-python/lit-${PV}[\${PYTHON_USEDEP}]") )"

S=${WORKDIR}/${P/_/}.src

# least intrusive of all
CMAKE_BUILD_TYPE=RelWithDebInfo

python_check_deps() {
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	LLVM_MAX_SLOT=${PV%%.*} llvm_pkg_setup
	use test && python-any-r1_pkg_setup
}

src_unpack() {
	default

	if use test; then
		mv llvm-* llvm || die
	fi
}

src_prepare() {
	# backport stand-alone build test fixes from master
	eapply "${FILESDIR}/4.0.0/0001-cmake-Support-running-tests-in-stand-alone-builds.patch"
	eapply "${FILESDIR}/4.0.0/0002-test-Use-LLD-specific-binary-library-dirs-when-build.patch"
	eapply "${FILESDIR}/4.0.0/0003-test-Fix-zlib-cond-when-building-stand-alone-clean-u.patch"

	eapply_user
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON

		-DLLVM_INCLUDE_TESTS=$(usex test)
		# TODO: fix detecting pthread upstream in stand-alone build
		-DPTHREAD_LIB='-lpthread'
	)
	use test && mycmakeargs+=(
		-DLLVM_BUILD_TESTS=ON
		-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
		-DLIT_COMMAND="${EPREFIX}/usr/bin/lit"
	)

	cmake-utils_src_configure
}

src_test() {
	cmake-utils_src_make check-lld
}
