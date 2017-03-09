# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="Production of surface images of proteins"
HOMEPAGE="http://hollow.sourceforge.net/"
#SRC_URI="mirror://sourceforge/${P}.zip"
SRC_URI="http://hollow.sourceforge.net/${P}.zip"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-3"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	sci-chemistry/pymol[${PYTHON_USEDEP}]"
DEPEND="${PYTHON_DEPS}
	app-arch/unzip"

src_install() {
	python_setup
	esvn_clean
	python_foreach_impl python_domodule pdbstruct
	python_moduleinto ${PN}
	python_foreach_impl python_domodule *.py hollow.txt

	python_foreach_impl python_newscript ${PN}.py ${PN}

	dodoc README
	python_optimize
}
