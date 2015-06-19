# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/apptools/apptools-4.2.1.ebuild,v 1.4 2015/03/08 23:39:13 pacho Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx

DESCRIPTION="Enthought Tool Suite: Application tools"
HOMEPAGE="http://code.enthought.com/projects/app_tools/ http://pypi.python.org/pypi/apptools"
SRC_URI="http://www.enthought.com/repo/ets/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

RDEPEND="dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/traits-4[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		${RDEPEND}
		>=dev-python/pyface-4[${PYTHON_USEDEP}]
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
		sci-visualization/mayavi[${PYTHON_USEDEP}]
		dev-python/traits[${PYTHON_USEDEP}]
		dev-python/traitsui[${PYTHON_USEDEP}]
	)"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	# Ignore test file that imports a long deprecated module of traits
	VIRTUALX_COMMAND="nosetests -I test_state_pickler.py" virtualmake
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
