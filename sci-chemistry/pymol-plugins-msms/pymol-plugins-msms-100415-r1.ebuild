# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1

DESCRIPTION="GUI for MSMS and displaying its results in PyMOL"
HOMEPAGE="http://www.biotec.tu-dresden.de/~hongboz/msms_pymol/msms_pymol.html"
SRC_URI="http://www.biotec.tu-dresden.de/~hongboz/msms_pymol/pymol_script/msms_pymol.py -> ${P}.py"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="BSD pymol"
IUSE=""

RDEPEND="
	sci-chemistry/msms-bin
	sci-chemistry/pymol[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

src_unpack() {
	mkdir "${S}" || die
	cp "${DISTDIR}"/${A} "${S}/" || die
}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-msms.patch
	sed \
		-e "s:GENTOOMSMS:${EPREFIX}/opt/bin/msms:g" \
		-e "s:GENTOOXYZRN:${EPREFIX}/usr/bin/pdb_to_xyzrn:g" \
		-i ${A} || die
}

src_install() {
	python_moduleinto pmg_tk/startup
	python_foreach_impl python_domodule ${P}.py
	python_foreach_impl python_optimize
}
