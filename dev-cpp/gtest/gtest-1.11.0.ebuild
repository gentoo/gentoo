# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Python is required for tests and some build tasks.
PYTHON_COMPAT=( python3_{9..10} )

inherit cmake-multilib python-any-r1

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/google/googletest"
else
	if [[ -z ${GOOGLETEST_COMMIT} ]]; then
		SRC_URI="https://github.com/google/googletest/archive/refs/tags/release-${PV}.tar.gz
			-> ${P}.tar.gz"
		S="${WORKDIR}"/googletest-release-${PV}
	else
		SRC_URI="https://github.com/google/googletest/archive/${GOOGLETEST_COMMIT}.tar.gz
			-> ${P}.tar.gz"
		S="${WORKDIR}"/googletest-${GOOGLETEST_COMMIT}
	fi
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="Google C++ Testing Framework"
HOMEPAGE="https://github.com/google/googletest"

LICENSE="BSD"
SLOT="0"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( ${PYTHON_DEPS} )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.10.0_p20200702-increase-clone-stack-size.patch
)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	sed -i -e '/set(cxx_base_flags /s:-Werror::' \
		googletest/cmake/internal_utils.cmake || die "sed failed!"
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_GMOCK=ON
		-DINSTALL_GTEST=ON

		# tests
		-Dgmock_build_tests=$(usex test)
		-Dgtest_build_tests=$(usex test)
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)
	cmake_src_configure
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
