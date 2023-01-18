# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DOCS_BUILDER="doxygen"
DOCS_DEPEND="
	dev-texlive/texlive-bibtexextra
	dev-texlive/texlive-fontsextra
	dev-texlive/texlive-fontutils
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
"
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1 docs

MY_PV=$(ver_cut 1-3)
MY_PF=LHAPDF-${MY_PV}

DESCRIPTION="Les Houches Parton Density Function unified library"
HOMEPAGE="https://lhapdf.hepforge.org/"
SRC_URI="https://www.hepforge.org/downloads/lhapdf/${MY_PF}.tar.gz"
S="${WORKDIR}/${MY_PF}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	$(python_gen_cond_dep '
	     >=dev-python/cython-0.19[${PYTHON_USEDEP}]
	')
"
RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	# Let cython reproduce this for more recent python versions
	rm wrappers/python/lhapdf.cpp || die
}

src_configure() {
	econf \
		--disable-static \
		--enable-python

	cd "${S}"/wrappers/python || die
	distutils-r1_src_prepare
}

src_compile() {
	emake all $(use doc && echo doxy)

	cd "${S}"/wrappers/python || die
	distutils-r1_src_compile
}

src_test() {
	emake -C tests
}

src_install() {
	default
	use doc && dodoc -r doc/doxygen/.
	use examples && dodoc examples/*.cc

	cd "${S}"/wrappers/python || die
	distutils-r1_src_install

	find "${ED}" -name '*.la' -delete || die
}
