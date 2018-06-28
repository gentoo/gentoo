# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils multilib

DESCRIPTION="High Energy Physics C++ library"
HOMEPAGE="http://cern.ch/clhep"
SRC_URI="http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/${P}.tgz"
LICENSE="GPL-3 LGPL-3"
SLOT="2/${PV}"
KEYWORDS="~amd64 ~hppa ppc ~x86 ~amd64-linux ~x86-linux ~x64-macos"

IUSE="doc test threads"
RDEPEND=""
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[latex] )"

S="${WORKDIR}/${PV}/CLHEP"

src_prepare() {
	cmake-utils_src_prepare

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
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DCLHEP_BUILD_DOCS=$(usex doc)
		-DCLHEP_SINGLE_THREAD=$(usex threads no yes)
	)
	DESTDIR="${ED}" cmake-utils_src_configure
}
