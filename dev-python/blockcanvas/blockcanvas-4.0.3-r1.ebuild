# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx

DESCRIPTION="Enthought Tool Suite: Numerical modeling"
HOMEPAGE="http://code.enthought.com/projects/block_canvas/ https://pypi.python.org/pypi/blockcanvas"
SRC_URI="http://www.enthought.com/repo/ets/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT=test

RDEPEND=">=dev-python/apptools-4[${PYTHON_USEDEP}]
	>=dev-python/chaco-4[${PYTHON_USEDEP}]
	>=dev-python/codetools-4[${PYTHON_USEDEP}]
	>=dev-python/etsdevtools-4[${PYTHON_USEDEP}]
	>=dev-python/pyface-4[${PYTHON_USEDEP}]
	>=dev-python/scimath-4[${PYTHON_USEDEP}]
	>=dev-python/traitsui-4[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/greenlet[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		${RDEPEND}
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
	)"

DOCS=( docs/{notes.txt,readme.txt} )

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	VIRTUALX_COMMAND="nosetests -v" virtualmake
}

python_install_all() {
	use doc && local DOHTML_DOCS=( docs/build/html/. )
	distutils-r1_python_install_all
}
