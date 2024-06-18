# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Python is required for tests and some build tasks.
PYTHON_COMPAT=( python3_{10..13} )

inherit cmake-multilib flag-o-matic python-any-r1 toolchain-funcs

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/google/googletest"
else
	if [[ -z ${GOOGLETEST_COMMIT} ]]; then
		SRC_URI="https://github.com/google/googletest/archive/refs/tags/v${PV}.tar.gz
			-> ${P}.tar.gz"
		S="${WORKDIR}"/googletest-${PV}
	else
		SRC_URI="https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT}.tar.gz
			-> ${P}.tar.gz"
		S="${WORKDIR}"/googletest-${GOOGLETEST_COMMIT}
	fi
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
fi

DESCRIPTION="Google C++ Testing Framework"
HOMEPAGE="https://github.com/google/googletest"

LICENSE="BSD"
SLOT="0"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( ${PYTHON_DEPS} )"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

multilib_src_configure() {
	if use arm && [[ $(tc-is-softfloat) =~ (softfp)|(no) ]]; then
		replace-flags -O* -O1 # bug #925093
	fi

	local mycmakeargs=(
		-DBUILD_GMOCK=ON
		-DINSTALL_GTEST=ON

		# tests
		-Dgmock_build_tests=$(usex test)
		-Dgtest_build_tests=$(usex test)
	)
	if use test; then
		if use x86 || use x86-linux; then
			append-cxxflags -ffloat-store # bug #905007
		fi
		mycmakeargs+=( -DPython3_EXECUTABLE="${PYTHON}" )
	fi

	cmake_src_configure
}

multilib_src_test() {
	# Exclude tests that fail with FEATURES="usersandbox"
	cmake_src_test -E "googletest-(death-test|port)-test"
}

multilib_src_install_all() {
	einstalldocs

	newdoc googletest/README.md README.googletest.md
	newdoc googlemock/README.md README.googlemock.md

	use doc && dodoc -r docs/.

	if use examples; then
		docinto examples
		dodoc googletest/samples/*.{cc,h}
	fi
}
