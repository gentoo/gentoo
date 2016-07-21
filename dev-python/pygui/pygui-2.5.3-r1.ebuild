# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P="PyGUI-${PV}"

DESCRIPTION="A cross-platform pythonic GUI API"
HOMEPAGE="http://www.cosc.canterbury.ac.nz/greg.ewing/python_gui/"
SRC_URI="http://www.cosc.canterbury.ac.nz/greg.ewing/python_gui/${MY_P}.tar.gz"

LICENSE="PyGUI"
SLOT=0
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND="dev-python/pygtk[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}

python_install_all() {
	use doc && local HTML_DOCS=( Doc/. )
	use examples && local EXAMPLES=( Demos/. )
	distutils-r1_python_install_all
}
