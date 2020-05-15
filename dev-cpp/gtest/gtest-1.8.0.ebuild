# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Python is required for tests and some build tasks.
PYTHON_COMPAT=( python3_6 )

inherit python-any-r1 cmake-multilib

DESCRIPTION="Google C++ Testing Framework"
HOMEPAGE="https://github.com/google/googletest"
SRC_URI="https://github.com/google/googletest/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

DEPEND="test? ( ${PYTHON_DEPS} )"
RDEPEND="!dev-cpp/gmock"

PATCHES=(
	"${FILESDIR}"/${PN}-9999-fix-py-tests.patch
	"${FILESDIR}"/${PN}-1.8.0-fix-gcc6-undefined-behavior.patch
	"${FILESDIR}"/${PN}-1.8.0-multilib-strict.patch
	"${FILESDIR}"/${PN}-1.8.0-increase-clone-stack-size.patch
)

S="${WORKDIR}"/googletest-release-${PV}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_GMOCK=ON
		-DBUILD_GTEST=ON
		-DLIB_INSTALL_DIR=$(get_libdir)
		-Dgtest_build_samples=OFF
		-Dgtest_disable_pthreads=OFF
		-DBUILD_SHARED_LIBS=ON

		# tests
		-Dgmock_build_tests=$(usex test)
		-Dgtest_build_tests=$(usex test)
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)
	cmake-utils_src_configure mycmakeargs
}

multilib_src_install_all() {
	einstalldocs

	if use doc; then
		docinto googletest
		dodoc -r googletest/docs/*
		docinto googlemock
		dodoc -r googlemock/docs/*
	fi

	if use examples; then
		docinto examples
		dodoc googletest/samples/*.{cc,h}
	fi
}
