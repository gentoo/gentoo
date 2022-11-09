# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# python3_11 fails
PYTHON_COMPAT=( python3_{8..10} )
inherit cmake python-single-r1

MYP=HepMC3-${PV}

DESCRIPTION="Event Record for Monte Carlo Generators"
HOMEPAGE="https://hepmc.web.cern.ch/hepmc/"
SRC_URI="https://hepmc.web.cern.ch/hepmc/releases/${MYP}.tar.gz"
S="${WORKDIR}/${MYP}"

LICENSE="GPL-3+"
SLOT="3"
KEYWORDS="~amd64"
IUSE="doc test examples python root"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"
BDEPEND="
	root? ( sci-physics/root:= )
	doc? (
		app-doc/doxygen[dot]
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-latexrecommended
	)
"

src_configure() {
	local mycmakeargs=(
		-DHEPMC3_ENABLE_ROOTIO=$(usex root ON OFF)
		-DHEPMC3_ENABLE_PYTHON=$(usex python ON OFF)
		-DHEPMC3_ENABLE_TEST=$(usex test ON OFF)
		-DHEPMC3_BUILD_DOCS=$(usex doc ON OFF)
		-DHEPMC3_BUILD_EXAMPLES=$(usex examples ON OFF)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	use examples && docompress -x /usr/share/doc/${PF}/examples
	python_optimize
}
