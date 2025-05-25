# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit fortran-2 cmake flag-o-matic python-single-r1

MYP=HepMC3-${PV}

DESCRIPTION="Event Record for Monte Carlo Generators"
HOMEPAGE="https://hepmc.web.cern.ch/hepmc/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.cern.ch/hepmc/HepMC3"
else
	SRC_URI="https://hepmc.web.cern.ch/hepmc/releases/${MYP}.tar.gz"
	S="${WORKDIR}/${MYP}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="3"
IUSE="doc test examples python root static-libs"
RESTRICT="!test? ( test )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
		')
	)
"
DEPEND="${RDEPEND}"
# Automagic compression dependencies in test and example.
# https://gitlab.cern.ch/hepmc/HepMC3/-/issues/99
# For now we install all of them...
BDEPEND="
	root? ( sci-physics/root:= )
	doc? (
		app-text/doxygen[dot]
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-latexrecommended
	)
	test? (
		sys-libs/zlib
		app-arch/xz-utils
		app-arch/bzip2
		app-arch/zstd
	)
	examples? (
		sys-libs/zlib
		app-arch/xz-utils
		app-arch/bzip2
		app-arch/zstd
	)
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	filter-lto # 941937 941936
	local mycmakeargs=(
		-DHEPMC3_PYTHON_VERSIONS="${EPYTHON/python/}"
		-DHEPMC3_ENABLE_ROOTIO=$(usex root ON OFF)
		-DHEPMC3_ENABLE_PYTHON=$(usex python ON OFF)
		-DHEPMC3_ENABLE_TEST=$(usex test ON OFF)
		-DHEPMC3_BUILD_DOCS=$(usex doc ON OFF)
		-DHEPMC3_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DHEPMC3_BUILD_STATIC_LIBS=$(usex static-libs ON OFF)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	use examples && docompress -x /usr/share/doc/${PF}/examples
	use python && python_optimize
}
