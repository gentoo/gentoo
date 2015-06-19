# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/clhep/clhep-2.1.4.1.ebuild,v 1.1 2013/11/25 21:59:14 bicatali Exp $

EAPI=5

inherit cmake-utils multilib

DESCRIPTION="High Energy Physics C++ library"
HOMEPAGE="http://www.cern.ch/clhep"
SRC_URI="http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/${P}.tgz"
LICENSE="GPL-3 LGPL-3"
SLOT="2/${PV}"
KEYWORDS="~amd64 ~hppa ~ppc ~x86 ~amd64-linux ~x86-linux"

IUSE="doc static-libs test"
RDEPEND=""
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base )"

S="${WORKDIR}/${PV}/CLHEP"

src_prepare() {
	# respect flags
	sed -i -e 's:-O::g' cmake/Modules/ClhepVariables.cmake || die
	# no batch mode to allow parallel building (bug #437482)
	sed -i \
		-e 's:-interaction=batchmode::g' \
		cmake/Modules/ClhepBuildTex.cmake || die
	# gentoo doc directory
	sed -i \
		-e "/DESTINATION/s:doc:share/doc/${PF}:" \
		cmake/Modules/ClhepBuildTex.cmake */doc/CMakeLists.txt || die
	# dont build test if not asked
	if ! use test; then
		sed -i \
			-e '/add_subdirectory(test)/d' \
			*/CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable test TESTING)
		$(cmake-utils_use doc CLHEP_BUILD_DOCS)
	)
	DESTDIR="${ED}" cmake-utils_src_configure
	use doc && MAKEOPTS+=" -j1"
}

src_install() {
	cmake-utils_src_install
	use static-libs || rm "${ED}"/usr/$(get_libdir)/*.a
}
