# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/codetools/codetools-4.1.0-r1.ebuild,v 1.1 2013/04/16 06:57:13 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx

DESCRIPTION="Enthought Tool Suite: Code analysis and execution tools"
HOMEPAGE="http://code.enthought.com/projects/code_tools/ http://pypi.python.org/pypi/codetools"
SRC_URI="http://www.enthought.com/repo/ets/${P}.tar.gz"

IUSE="doc examples test"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="BSD"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/scimath-4[${PYTHON_USEDEP}]
	>=dev-python/traits-4[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		${RDEPEND}
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
	)"

PATCHES=( "${FILESDIR}"/${PN}-4.0.0-test.patch )

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	VIRTUALX_COMMAND="nosetests" virtualmake
}

python_install_all() {
	distutils-r1_python_install_all

	use doc && dohtml -r docs/build/html/

	if use examples; then
		docompress -x usr/share/doc/${PF}/examples/
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
