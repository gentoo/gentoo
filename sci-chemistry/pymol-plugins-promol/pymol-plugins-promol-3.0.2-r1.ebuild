# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/pymol-plugins-promol/pymol-plugins-promol-3.0.2-r1.ebuild,v 1.5 2015/02/12 08:15:22 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="Fast and accurate regognition of active sites"
HOMEPAGE="http://www.rit.edu/cos/ezviz/ProMOL_dl.html"
SRC_URI="http://www.rit.edu/cos/ezviz/ProMOL.zip -> ${P}.zip"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
LICENSE="all-rights-reserved"
IUSE=""

RESTRICT="mirror bindist"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	virtual/pmw[${PYTHON_USEDEP}]
	sci-chemistry/pymol[${PYTHON_USEDEP}]"
DEPEND=""

S="${WORKDIR}/ProMOL Folder"

src_prepare() {
	python_copy_sources
	preparation() {
		cd "${BUILD_DIR}" || die
		sed \
			-e "s:./modules/pmg_tk/startup:${EPREFIX}/$(python_get_sitedir)/pmg_tk/startup/ProMol:g" \
			-i ProMOL_302.py || die
	}
	python_foreach_impl preparation
}

src_install(){
	dodoc *doc
	dohtml -r Thanks.html EDMHelp.htm Help

	installation() {
		cd "${BUILD_DIR}" || die
		python_moduleinto pmg_tk/startup/ProMol
		python_domodule PDB_List AminoPics Motifs *GIF pdb_entry_type.txt Master.txt Scripts
		python_moduleinto pmg_tk/startup
		python_domodule *.py
		dosym ../../../../../../share/doc/${PF}/html/Help \
			$(python_get_sitedir)/pmg_tk/startup/ProMol/Help
		dosym ../../../../../../share/doc/${PF}/html/Thanks.html \
			$(python_get_sitedir)/pmg_tk/startup/ProMol/Thanks.html
		dosym ../../../../../../share/doc/${PF}/html/EDMHelp.htm \
			$(python_get_sitedir)/pmg_tk/startup/ProMol/EDMHelp.htm
	}
	python_foreach_impl installation
}
