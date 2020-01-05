# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P="${P/pyx/PyX}"

DESCRIPTION="Python package for the generation of encapsulated PostScript figures"
HOMEPAGE="https://pyx.sourceforge.net/
	https://pypi.org/project/PyX/"
SRC_URI="mirror://sourceforge/pyx/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="virtual/tex-base
		dev-texlive/texlive-basic"

DEPEND="${RDEPEND}
	doc? ( virtual/latex-base
		dev-python/sphinx[latex,${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	distutils-r1_src_prepare
	sed -i \
		-e 's/^build_t1code=.*/build_t1code=1/' \
		-e 's/^build_pykpathsea=.*/build_pykpathsea=1/' \
		setup.cfg || die "setup.cfg fix failed"
}

python_compile_all() {
	if use doc; then
		VARTEXFONTS="${T}"/fonts emake -C "${S}"/faq latexpdf
	fi
}

python_install_all() {
	use doc && dodoc faq/_build/latex/pyxfaq.pdf
	distutils-r1_python_install_all
}
