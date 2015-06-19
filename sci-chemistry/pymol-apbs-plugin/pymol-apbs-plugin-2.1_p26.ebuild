# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/pymol-apbs-plugin/pymol-apbs-plugin-2.1_p26.ebuild,v 1.3 2015/04/08 18:22:14 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1

MY_PV="${PV##*_p}"

DESCRIPTION="APBS plugin for pymol"
HOMEPAGE="http://sourceforge.net/projects/pymolapbsplugin/"
SRC_URI="http://sourceforge.net/p/pymolapbsplugin/code/${MY_PV}/tree/trunk/src/apbsplugin.py?format=raw -> ${P}.py"

SLOT="0"
KEYWORDS="amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
LICENSE="pymol"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	sci-chemistry/apbs
	sci-chemistry/pdb2pqr
	!<sci-chemistry/pymol-1.2.2-r1"
DEPEND="${RDEPEND}"

src_unpack() {
	mkdir "${S}"
	cp "${DISTDIR}"/${P}.py "${S}"/
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-tcltk8.6.patch
	python_copy_sources
}

src_install() {
	installation() {
		cd "${BUILD_DIR}" || die
		sed \
			-e "s:^APBS_BINARY_LOCATION.*:APBS_BINARY_LOCATION = \"${EPREFIX}/usr/bin/apbs\":g" \
			-e "s:^APBS_PSIZE_LOCATION.*:APBS_PSIZE_LOCATION = \"${EPREFIX}/$(python_get_sitedir)/pdb2pqr/src/\":g" \
			-e "s:^APBS_PDB2PQR_LOCATION.*:APBS_PDB2PQR_LOCATION = \"${EPREFIX}/$(python_get_sitedir)/pdb2pqr/\":g" \
			-e "s:^TEMPORARY_FILE_DIR.*:TEMPORARY_FILE_DIR = \"./\":g" \
			${P}.py > apbs_tools.py

		python_moduleinto pmg_tk/startup
		python_domodule apbs_tools.py || die
		python_optimize
	}
	python_parallel_foreach_impl installation
}
