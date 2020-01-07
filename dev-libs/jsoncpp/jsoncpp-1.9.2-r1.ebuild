# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit cmake-utils python-any-r1

DESCRIPTION="C++ JSON reader and writer"
HOMEPAGE="https://github.com/open-source-parsers/jsoncpp"
SRC_URI="https://github.com/open-source-parsers/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( public-domain MIT )"
SLOT="0/22"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="
	doc? (
		app-doc/doxygen
		${PYTHON_DEPS}
	)
	test? (
		${PYTHON_DEPS}
	)"
RDEPEND=""

pkg_setup() {
	if use doc || use test; then
		python-any-r1_pkg_setup
	fi
}

src_configure() {
	local mycmakeargs=(
		-DJSONCPP_WITH_TESTS=$(usex test)
		-DJSONCPP_WITH_POST_BUILD_UNITTEST=OFF
		-DJSONCPP_WITH_CMAKE_PACKAGE=ON

		-DBUILD_SHARED_LIBS=ON

		# Follow Debian, Ubuntu, Arch convention for headers location
		# bug #452234
		-DCMAKE_INSTALL_INCLUDEDIR=include/jsoncpp

		# Disable implicit ccache use
		-DCCACHE_FOUND=OFF
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use doc; then
		cp "${BUILD_DIR}"/version . || die
		"${EPYTHON}" doxybuild.py --doxygen="${EPREFIX}"/usr/bin/doxygen || die
		HTML_DOCS=( dist/doxygen/jsoncpp*/. )
	fi
}

src_test() {
	cmake-utils_src_make jsoncpp_check
}
