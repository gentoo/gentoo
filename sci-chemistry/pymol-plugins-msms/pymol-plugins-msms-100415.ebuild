# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit eutils python

DESCRIPTION="GUI for MSMS and displaying its results in PyMOL"
HOMEPAGE="http://www.biotec.tu-dresden.de/~hongboz/msms_pymol/msms_pymol.html"
SRC_URI="http://www.biotec.tu-dresden.de/~hongboz/msms_pymol/pymol_script/msms_pymol.py -> ${P}.py"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="BSD pymol"
IUSE=""

RDEPEND="
	sci-chemistry/msms-bin
	sci-chemistry/pymol"
DEPEND="${RDEPEND}"

src_unpack() {
	mkdir "${S}"
	cp "${DISTDIR}"/${A} "${S}/"
}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-msms.patch
	sed \
		-e "s:GENTOOMSMS:${EPREFIX}/opt/bin/msms:g" \
		-e "s:GENTOOXYZRN:${EPREFIX}/usr/bin/pdb_to_xyzrn:g" \
		-i ${A} || die
}

src_install() {
	installation() {
		insinto $(python_get_sitedir)/pmg_tk/startup
		doins ${P}.py
	}
	python_execute_function installation
}

pkg_postinst() {
	python_mod_optimize pmg_tk/startup/${P}.py
}

pkg_postrm() {
	python_mod_cleanup pmg_tk/startup/${P}.py
}
