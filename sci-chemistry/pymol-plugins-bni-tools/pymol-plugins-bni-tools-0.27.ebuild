# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-r1 versionator

MY_PN="${PN#pymol-plugins-}"
MY_P="${MY_PN}-$(delete_version_separator 1)"
MY_P_DOT="${MY_PN}-${PV}"

DESCRIPTION="Gives Pymol additional functionalities and presets to the PyMOL GUI"
HOMEPAGE="http://bni-tools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_PN}/${MY_P_DOT}/${MY_P}.zip"

LICENSE="CNRI"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	sci-chemistry/pymol[${PYTHON_USEDEP}]"
DEPEND="${PYTHON_DEPS}
	app-arch/unzip"

S="${WORKDIR}"

src_install() {
	python_moduleinto pmg_tk/startup
	python_foreach_impl python_domodule bni-tools.py
	python_foreach_impl python_optimize
	dodoc readme.txt
	dohtml ShortCommandDescription.html
}
