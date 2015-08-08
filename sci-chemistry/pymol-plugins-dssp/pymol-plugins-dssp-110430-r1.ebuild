# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="DSSP Plugin for PyMOL"
HOMEPAGE="http://www.biotec.tu-dresden.de/~hongboz/dssp_pymol/dssp_pymol.html"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.py.xz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="BSD pymol"
IUSE=""

RDEPEND="
	sci-chemistry/dssp
	sci-biology/stride
	sci-chemistry/pymol[${PYTHON_USEDEP}]"
DEPEND=""

S="${WORKDIR}"

src_prepare() {
	sed \
		-e "s:GENTOO_DSSP:${EPREFIX}/usr/bin/dssp:g" \
		-e "s:GENTOO_STRIDE:${EPREFIX}/usr/bin/stride:g" \
		-i ${P}.py || die
}

src_install() {
	python_moduleinto pmg_tk/startup
	python_parallel_foreach_impl python_domodule ${P}.py
	python_parallel_foreach_impl python_optimize
}
