# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="High Energy Physics C++ library"
HOMEPAGE="http://proj-clhep.web.cern.ch/proj-clhep/"
SRC_URI="http://proj-clhep.web.cern.ch/proj-clhep/dist1/${P}.tgz"
LICENSE="GPL-3 LGPL-3"
SLOT="2/${PV}"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"

IUSE="doc test threads"
RESTRICT="!test? ( test )"

BDEPEND="
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
"

S="${WORKDIR}/${PV}/CLHEP"

src_prepare() {
	cmake_src_prepare

	# respect flags
	sed -i -e 's:-O::g' cmake/Modules/ClhepVariables.cmake || die
	# dont build test if not asked
	if ! use test; then
		cmake_comment_add_subdirectory test
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
		-DCLHEP_BUILD_DOCS=$(usex doc)
		-DCLHEP_SINGLE_THREAD=$(usex threads no yes)
	)
	cmake_src_configure
}
