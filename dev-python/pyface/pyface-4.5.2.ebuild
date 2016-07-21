# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# https://github.com/enthought/pyface/issues/40 confirms only py2.7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx

DESCRIPTION="Enthought Tool Suite: Traits-capable windowing framework"
HOMEPAGE="https://github.com/enthought/pyface"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples test"

RDEPEND="
	>=dev-python/traits-4.1[${PYTHON_USEDEP}]
	|| (
		dev-python/wxpython:*[${PYTHON_USEDEP}]
		dev-python/PyQt4[${PYTHON_USEDEP}]
		dev-python/pyside[${PYTHON_USEDEP}]
	)"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/traitsui[${PYTHON_USEDEP}]
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
	)"

python_test() {
	export ETS_TOOLKIT=qt4
	export QT_API=pyqt
	# set nosetests to ignore tests unpassable by these vars.
	VIRTUALX_COMMAND="nosetests" virtualmake -v -I 'composite_grid_model_test_case*' \
		-I 'simple_grid_model_test_case*' \
		-I 'test_split_editor_area_pane*'
}

python_install_all() {
	use examples && EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
