# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
inherit distutils-r1

DESCRIPTION="a pure-python graphics and GUI library built on PyQt/PySide and numpy"
HOMEPAGE="http://www.pyqtgraph.org/ https://github.com/pyqtgraph/pyqtgraph"
SRC_URI="https://github.com/pyqtgraph/${PN}/archive/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples opengl"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	|| (
		dev-python/PyQt5[${PYTHON_USEDEP}]
		dev-python/PyQt4[${PYTHON_USEDEP}]
		dev-python/pyside[${PYTHON_USEDEP}]
	)
	opengl? ( dev-python/pyopengl[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"

S=${WORKDIR}/${PN}-${P}

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
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
