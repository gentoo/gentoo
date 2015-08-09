# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx

DESCRIPTION="Enthought Tool Suite: framework for writing declarative interfaces"
HOMEPAGE="http://code.enthought.com/projects/enaml/ http://pypi.python.org/pypi/enaml"
SRC_URI="http://www.enthought.com/repo/ets/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

RDEPEND="
	dev-python/casuarius[${PYTHON_USEDEP}]
	dev-python/ply[${PYTHON_USEDEP}]
	dev-python/traits[${PYTHON_USEDEP}]
	|| (
		dev-python/wxpython:*[${PYTHON_USEDEP}] \
		dev-python/PyQt4[${PYTHON_USEDEP}] \
		dev-python/pyside[${PYTHON_USEDEP}] )"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/wxpython[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/pyside[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# crash doc and gone upstream (> 0.2.0)
	sed -i -e '/enthought.debug.api/d' enamldoc/sphinx_ext.py || die
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	export ETS_TOOLKIT=qt4
	export QT_API=pyside
	VIRTUALX_COMMAND="nosetests -v" virtualmake
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
