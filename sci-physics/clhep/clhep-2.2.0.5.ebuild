# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="High Energy Physics C++ library"
HOMEPAGE="http://proj-clhep.web.cern.ch/proj-clhep/"
SRC_URI="http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/${P}.tgz"
LICENSE="GPL-3 LGPL-3"
SLOT="2/${PV}"
KEYWORDS="amd64 hppa ppc x86 ~amd64-linux ~x86-linux ~x64-macos"

IUSE="doc static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="doc? ( virtual/latex-base )"

S="${WORKDIR}/${PV}/CLHEP"

src_prepare() {
	cmake-utils_src_prepare

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
		-DCLHEP_BUILD_DOCS=$(usex doc)
	)
	DESTDIR="${ED}" cmake-utils_src_configure
	use doc && MAKEOPTS+=" -j1"
}

src_install() {
	cmake-utils_src_install
	if ! use static-libs; then
		rm "${ED}"/usr/$(get_libdir)/*.a || die
	fi
}
