# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MYP=HepMC-${PV}

DESCRIPTION="Event Record for Monte Carlo Generators"
HOMEPAGE="https://hepmc.web.cern.ch/hepmc/"
SRC_URI="http://lcgapp.cern.ch/project/simu/HepMC/download/${MYP}.tar.gz"
S="${WORKDIR}/${MYP}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="cm doc examples gev test"
RESTRICT="!test? ( test )"

BDEPEND="
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-latexrecommended
	)"

src_prepare() {
	cmake_src_prepare

	sed -i -e '/add_subdirectory(doc)/d' CMakeLists.txt || die
	# CMake doc building broken
	# gentoo doc directory
	#sed -i \
	#	-e "s:share/HepMC/doc:share/doc/${PF}:" \
	#	doc/CMakeLists.txt || die

	# gentoo examples directory
	sed -i \
		-e "s:share/HepMC:share/doc/${PF}:" \
		$(find examples -name CMakeLists.txt) || die

	# respect user's flags
	sed -i \
		-e "s/-O -ansi -pedantic -Wall//g" \
		cmake/Modules/HepMCVariables.cmake || die

	# gentoo libdir love
	sed -i \
		-e '/DESTINATION/s/lib/lib${LIB_SUFFIX}/g' \
		{src,fio}/CMakeLists.txt || die

	# remove targets if use flags not set
	if ! use examples; then
		sed -i -e '/add_subdirectory(examples)/d' CMakeLists.txt || die
	fi
	if ! use test; then
		sed -i -e '/add_subdirectory(test)/d' CMakeLists.txt || die
	fi

	# remove static libs
	sed -i \
		-e '/(HepMC\(fio\|\)S/d' \
		-e '/TARGETS/s/HepMC\(fio\|\)S//' \
		{src,fio}/CMakeLists.txt || die
}

src_configure() {
	# use MeV over GeV and mm over cm
	local mycmakeargs=(
		-Dlength=$(usex cm CM MM)
		-Dmomentum=$(usex gev GEV MEV)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		cd doc || die
		./buildDoc.sh || die
		./buildDoxygen.sh || die
		HTML_DOCS=( doc/html/. )
	fi
}

src_install() {
	cmake_src_install
	use doc && dodoc doc/*.pdf
}
