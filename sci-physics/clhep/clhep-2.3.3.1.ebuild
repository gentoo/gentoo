# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

CMAKE_MIN_VERSION=3.2

inherit cmake-utils multilib

DESCRIPTION="High Energy Physics C++ library"
HOMEPAGE="http://cern.ch/clhep"
SRC_URI="http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/${P}.tgz"
LICENSE="GPL-3 LGPL-3"
SLOT="2/${PV}"
KEYWORDS="~amd64 ~hppa ~ppc ~x86 ~amd64-linux ~x86-linux"

IUSE="doc static-libs test"
RDEPEND=""
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[latex] )"

S="${WORKDIR}/${PV}/CLHEP"

src_prepare() {
	# respect flags
	sed -i -e 's:-O::g' cmake/Modules/ClhepVariables.cmake || die
	# dont build test if not asked
	if ! use test; then
		sed -i \
			-e '/add_subdirectory(test)/d' \
			*/CMakeLists.txt || die
	fi
	# gentoo doc directory
	if use doc; then
		grep -rl 'share/doc/CLHEP' |
		xargs sed -i \
			-e "s:share/doc/CLHEP:share/doc/${PF}:" \
			{.,*}/CMakeLists.txt || die
	fi
}

src_configure() {
	append-cxxflags $(test-flags-CXX -std=c++11)
	local mycmakeargs=(
		$(cmake-utils_use test ENABLE_TESTING)
		$(cmake-utils_use doc CLHEP_BUILD_DOCS)
	)
	DESTDIR="${ED}" cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	use static-libs || rm "${ED}"/usr/$(get_libdir)/*.a
}
