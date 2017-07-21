# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="DSSP Plugin for PyMOL"
HOMEPAGE="http://www.biotec.tu-dresden.de/~hongboz/dssp_pymol/dssp_pymol.html"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}.py.xz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="BSD pymol"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	sci-chemistry/dssp
	sci-biology/stride
	sci-chemistry/pymol[${PYTHON_USEDEP}]"

S="${WORKDIR}"

src_prepare() {
	sed \
		-e "s:GENTOO_DSSP:${EPREFIX}/usr/bin/dssp:g" \
		-e "s:GENTOO_STRIDE:${EPREFIX}/usr/bin/stride:g" \
		-i ${P}.py || die
}

src_install() {
	python_moduleinto pmg_tk/startup
	python_foreach_impl python_domodule ${P}.py
	python_foreach_impl python_optimize
}
