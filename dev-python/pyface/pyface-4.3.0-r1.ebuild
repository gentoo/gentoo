# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyface/pyface-4.3.0-r1.ebuild,v 1.4 2015/06/07 15:27:50 jlec Exp $

EAPI=5

# https://github.com/enthought/pyface/issues/40 confirms only py2.7
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx

DESCRIPTION="Enthought Tool Suite: Traits-capable windowing framework"
HOMEPAGE="https://github.com/enthought/pyface http://pypi.python.org/pypi/pyface"
SRC_URI="http://www.enthought.com/repo/ets/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

RDEPEND="
	>=dev-python/traits-4.1[${PYTHON_USEDEP}]
	|| (
		dev-python/wxpython:*[${PYTHON_USEDEP}]
		dev-python/PyQt4[${PYTHON_USEDEP}]
		dev-python/pyside[${PYTHON_USEDEP}]
	)"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		${RDEPEND}
		dev-python/traitsui[${PYTHON_USEDEP}]
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
	)"

DOCS=( docs/*.txt )

python_compile_all() {
	use doc && virtualmake -C docs html
}

python_test() {
	export ETS_TOOLKIT=qt4
	export QT_API=pyqt
	# set nosetests to ignore tests unpassable by these vars.
	VIRTUALX_COMMAND="nosetests" virtualmake -v -I 'composite_grid_model_test_case*' \
		-I 'simple_grid_model_test_case*' \
		-I 'test_split_editor_area_pane*'
}

python_install_all() {
	find -name "*LICENSE*.txt" -delete
	use doc && dohtml -r docs/build/html/*

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
