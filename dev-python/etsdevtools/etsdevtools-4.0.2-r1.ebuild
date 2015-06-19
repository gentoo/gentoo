# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/etsdevtools/etsdevtools-4.0.2-r1.ebuild,v 1.5 2015/03/08 23:46:52 pacho Exp $

EAPI=5

PYTHON_COMPAT=python2_7

inherit distutils-r1 virtualx

DESCRIPTION="Enthought Tool Suite: Tools to support Python development"
HOMEPAGE="http://code.enthought.com/projects/dev_tools.php http://pypi.python.org/pypi/etsdevtools"
SRC_URI="http://www.enthought.com/repo/ets/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/traits[${PYTHON_USEDEP}]"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		${RDEPEND}
		>=dev-python/traitsui-4[${PYTHON_USEDEP}]
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
		x11-apps/xhost
	)"

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	VIRTUALX_COMMAND="nosetests -v" virtualmake
}

python_install_all() {
	find -name "*LICENSE*.txt" -delete
	use doc && dohtml -r docs/build/html/*

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
