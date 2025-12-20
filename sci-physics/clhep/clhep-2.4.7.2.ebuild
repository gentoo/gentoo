# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake dot-a

MY_PV=$(ver_rs 1- '_')
MY_P=CLHEP_${MY_PV}

DESCRIPTION="High Energy Physics C++ library"
HOMEPAGE="
	http://proj-clhep.web.cern.ch/proj-clhep/
	https://gitlab.cern.ch/CLHEP/CLHEP
"
SRC_URI="https://gitlab.cern.ch/CLHEP/CLHEP/-/archive/${MY_P}/CLHEP-${MY_P}.tar.bz2"

S="${WORKDIR}/CLHEP-${MY_P}"

LICENSE="GPL-3 LGPL-3"
SLOT="2/${PV}"
KEYWORDS="~amd64 ~x86 ~x64-macos"

IUSE="doc static-libs test threads"
RESTRICT="!test? ( test )"

BDEPEND="
	doc? (
		app-text/doxygen
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
"

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
	use static-libs && lto-guarantee-fat

	local mycmakeargs=(
		-DCLHEP_BUILD_DOCS=$(usex doc)
		-DCLHEP_BUILD_STATIC_LIBS=$(usex static-libs)
		-DCLHEP_SINGLE_THREAD=$(usex threads no yes)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	use static-libs && strip-lto-bytecode
}
