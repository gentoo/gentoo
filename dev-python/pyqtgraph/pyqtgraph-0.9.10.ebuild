# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )
inherit distutils-r1

DESCRIPTION="a pure-python scientific graphics and GUI library built on PyQt4/PySide and numpy"
HOMEPAGE="http://www.pyqtgraph.org/ https://github.com/pyqtgraph/pyqtgraph"
SRC_URI="http://www.pyqtgraph.org/downloads/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples opengl"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	|| (
		dev-python/PyQt4[${PYTHON_USEDEP}]
		dev-python/pyside[${PYTHON_USEDEP}]
	)
	opengl? ( dev-python/pyopengl[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"

python_prepare_all() {
	distutils-r1_python_prepare_all

	# fix distutils warning
	sed -i 's/install_requires/requires/' setup.py || die

	if ! use opengl; then
		rm -r pyqtgraph/opengl || die
	fi
}

python_compile_all() {
	use doc && emake -C doc html
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
