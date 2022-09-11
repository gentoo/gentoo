# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_9 )
DOCS_BUILDER="doxygen"
DOCS_DEPEND="
	dev-texlive/texlive-bibtexextra
	dev-texlive/texlive-fontsextra
	dev-texlive/texlive-fontutils
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
"
inherit python-single-r1 docs

MY_PV=$(ver_cut 1-3)
MY_PF=LHAPDF-${MY_PV}

DESCRIPTION="Les Houches Parton Density Function unified library"
HOMEPAGE="https://lhapdf.hepforge.org/"
SRC_URI="https://www.hepforge.org/downloads/lhapdf/${MY_PF}.tar.gz"
S="${WORKDIR}/${MY_PF}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	dev-libs/boost:=
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

src_configure() {
	CONFIG_SHELL="${EPREFIX}/bin/bash" \
	econf \
		--disable-static \
		--enable-python
}

src_compile() {
	emake all $(use doc && echo doxy)
}

src_test() {
	emake -C tests
}

src_install() {
	default
	use doc && dodoc -r doc/doxygen/.
	use examples && dodoc examples/*.cc

	find "${ED}" -name '*.la' -delete || die
}
