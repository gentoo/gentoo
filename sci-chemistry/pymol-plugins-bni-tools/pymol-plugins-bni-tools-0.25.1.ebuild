# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
SUPPORT_PYTHON_ABIS="1"

inherit python versionator

MY_PN="${PN#pymol-plugins-}"
MY_P="${MY_PN}-$(delete_version_separator 2)"

DESCRIPTION="Gives Pymol additional functionalities and presets to the PyMOL GUI"
HOMEPAGE="http://bni-tools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.zip"

LICENSE="CNRI"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="sci-chemistry/pymol"
DEPEND="app-arch/unzip"
RESTRICT_PYTHON_ABIS="2.4 3.*"

src_install(){
	installation() {
		insinto $(python_get_sitedir)/pmg_tk/startup/
		doins bni-tools.py || die "Failed to install ${P}"
	}
	python_execute_function installation
	dodoc readme.txt || die "No dodoc"
}

pkg_postinst(){
	python_mod_optimize pmg_tk/startup
}

pkg_postrm() {
	python_mod_cleanup pmg_tk/startup
}
