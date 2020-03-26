# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Python is required for tests and some build tasks.
PYTHON_COMPAT=( python2_7 )
CMAKE_ECLASS=cmake
inherit cmake-multilib python-any-r1

MY_PV=1.10.x

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/google/googletest"
else
	if [[ -z ${GOOGLETEST_COMMIT} ]]; then
		URI_PV=v${MY_PV:-${PV}}
	else
		URI_PV=${MY_PV:=${GOOGLETEST_COMMIT}}
	fi
	SRC_URI="https://github.com/google/googletest/archive/${URI_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
	S="${WORKDIR}"/googletest-${MY_PV}
fi

DESCRIPTION="Google C++ Testing Framework"
HOMEPAGE="https://github.com/google/googletest"

LICENSE="BSD"
SLOT="0"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

DEPEND="test? ( ${PYTHON_DEPS} )"
RDEPEND="!dev-cpp/gmock"

PATCHES=(
	"${FILESDIR}"/${PN}-1.9.0_pre20190607-increase-clone-stack-size.patch
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

	if use doc; then
		docinto googletest
		dodoc -r googletest/docs/.
		docinto googlemock
		dodoc -r googlemock/docs/.
	fi

	if use examples; then
		docinto examples
		dodoc googletest/samples/*.{cc,h}
	fi
}
