# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/jsoncpp/jsoncpp-0.10.2-r1.ebuild,v 1.6 2015/07/15 17:54:08 klausman Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-any-r1

DESCRIPTION="C++ JSON reader and writer"
HOMEPAGE="https://github.com/open-source-parsers/jsoncpp"
SRC_URI="https://github.com/open-source-parsers/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( public-domain MIT )"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ~mips ppc64 x86"
IUSE="doc test"

DEPEND="
	doc? (
		app-doc/doxygen
		${PYTHON_DEPS}
	)
	test? (
		${PYTHON_DEPS}
	)"
RDEPEND=""

PATCHES=(
	# fix broken path subst in .pc file
	"${FILESDIR}"/jsoncpp-1.6.2-fix-pkgconfig.patch
)

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
		-DINCLUDE_INSTALL_DIR="${EPREFIX}"/usr/include/jsoncpp
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use doc; then
		"${EPYTHON}" doxybuild.py --doxygen=/usr/bin/doxygen || die
	fi
}

src_test() {
	emake -C "${BUILD_DIR}" jsoncpp_check
}

src_install() {
	cmake-utils_src_install

	if use doc; then
		dohtml dist/doxygen/jsoncpp*/*
	fi
}
