# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/scimath/scimath-4.1.2-r1.ebuild,v 1.4 2015/03/08 23:58:37 pacho Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx

DESCRIPTION="Enthought Tool Suite: Scientific and mathematical tools"
HOMEPAGE="http://code.enthought.com/projects/sci_math/ http://pypi.python.org/pypi/scimath"
SRC_URI="http://www.enthought.com/repo/ets/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
DISTUTILS_IN_SOURCE_BUILD=1

RDEPEND=">=dev-python/traits-4.1[${PYTHON_USEDEP}]
	>=dev-python/traitsui-4.1[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		${RDEPEND}
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
		x11-apps/xhost
	)"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	# ONE test assumes PYTHONPATH in its own dir!!!
	PYTHONPATH=build/lib/:build/lib/scimath/interpolate/
	VIRTUALX_COMMAND="nosetests" virtualmake
}

python_install_all() {
	use doc && HTML_DOCS=( docs/build/html/. )
	distutils-r1_python_install_all
}
