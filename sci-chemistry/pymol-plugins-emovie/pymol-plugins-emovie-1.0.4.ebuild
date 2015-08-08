# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

SUPPORT_PYTHON_ABIS="1"

inherit eutils python

DESCRIPTION="eMovie is a plug-in tool for the molecular visualization program PyMOL"
SRC_URI="http://www.weizmann.ac.il/ISPC/eMovie_package.zip"
HOMEPAGE="http://www.weizmann.ac.il/ISPC/eMovie.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64 ~x86-linux ~amd64-linux"
IUSE=""

RDEPEND=">sci-chemistry/pymol-0.99"
DEPEND="app-arch/unzip"
#RESTRICT_PYTHON_ABIS="3.*"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-indent.patch

	mkdir ${P}
	mv e* ${P}/

	python_copy_sources

	conversion() {
		[[ "${PYTHON_ABI}" == 2.* ]] && return

		2to3-${PYTHON_ABI} -w eMovie.py > /dev/null
	}
	python_execute_function --action-message 'Applying patches for Python ${PYTHON_ABI}' --failure-message 'Applying patches for Python ${PYTHON_ABI} failed' -s conversion
}

src_install(){
	installation() {
		insinto $(python_get_sitedir)/pmg_tk/startup/
		doins eMovie.py || die
	}
	python_execute_function -s installation
}

pkg_postinst(){
	python_mod_optimize pmg_tk/startup
}

pkg_postrm() {
	python_mod_cleanup pmg_tk/startup
}
