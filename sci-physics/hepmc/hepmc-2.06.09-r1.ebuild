# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

MYP=HepMC-${PV}

DESCRIPTION="Event Record for Monte Carlo Generators"
HOMEPAGE="http://lcgapp.cern.ch/project/simu/HepMC/"
SRC_URI="http://lcgapp.cern.ch/project/simu/HepMC/download/${MYP}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="cm doc examples gev static-libs test"

RDEPEND=""
DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen
		|| (
			dev-texlive/texlive-latex
			dev-tex/floatflt
		)
	)"

S="${WORKDIR}/${MYP}"

DOCS=( ChangeLog AUTHORS )

src_prepare() {
	sed -i -e '/add_subdirectory(doc)/d' CMakeLists.txt
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
	use examples || sed -i -e '/add_subdirectory(examples)/d' CMakeLists.txt
	use test || sed -i -e '/add_subdirectory(test)/d' CMakeLists.txt
	if ! use static-libs; then
		sed -i \
			-e '/(HepMC\(fio\|\)S/d' \
			-e '/TARGETS/s/HepMC\(fio\|\)S//' \
			{src,fio}/CMakeLists.txt || die
	fi
}

src_configure() {
	# use MeV over GeV and mm over cm
	local length_conf="MM"
	use cm && length_conf="CM"
	local momentum_conf="MEV"
	use gev && momentum_conf="GEV"
	mycmakeargs+=(
		-Dlength=${length_conf}
		-Dmomentum=${momentum_conf}
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc; then
		cd doc
		./buildDoc.sh || die
		./buildDoxygen.sh || die
	fi
}

src_install() {
	cmake-utils_src_install
	use doc && dodoc doc/*.pdf && dohtml -r doc/html/*
}
