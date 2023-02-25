# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit cmake python-single-r1

MYPN=HepMC3
MYP=${MYPN}-${PV}

DESCRIPTION="Event Record for Monte Carlo Generators"
HOMEPAGE="https://hepmc.web.cern.ch/hepmc/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.cern.ch/hepmc/HepMC3"
else
	COMMIT="e05d32ebac8705c0097e9e7d00ce815a205110db"
	SRC_URI="https://gitlab.cern.ch/${PN}/${MYPN}/-/archive/${COMMIT}/${MYPN}-${COMMIT}.tar.gz"
	S="${WORKDIR}/${MYPN}-${COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="3"
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
