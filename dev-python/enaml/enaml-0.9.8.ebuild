# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/enaml/enaml-0.9.8.ebuild,v 1.4 2015/06/03 18:03:31 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx flag-o-matic

DESCRIPTION="Enthought Tool Suite: framework for writing declarative interfaces"
HOMEPAGE="http://code.enthought.com/projects/enaml/ http://pypi.python.org/pypi/enaml"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="examples test"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/atom-0.3.8[${PYTHON_USEDEP}]
	>=dev-python/kiwisolver-0.1.2[${PYTHON_USEDEP}]
	>=dev-python/ply-3.4[${PYTHON_USEDEP}]
	|| (
		dev-python/wxpython:*[${PYTHON_USEDEP}] \
		dev-python/PyQt4[${PYTHON_USEDEP}] \
		dev-python/pyside[${PYTHON_USEDEP}] )"

DEPEND="${RDEPEND}
	test? ( dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/wxpython[${PYTHON_USEDEP}]
		dev-python/pyside[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}] )"

# The testsuite antagonises gentoo conventions far beyond what can currently be dealt with
# It also passes all once run
RESTRICT="test"

# Doc build now fails, missing required folder, use doc removed for now
# https://github.com/nucleic/enaml/issues/170
#python_compile_all() {
#	use doc && emake -C docs html
#}

python_prepare_all() {
	append-flags -fno-strict-aliasing
	distutils-r1_python_prepare_all
}

python_test() {
	export ETS_TOOLKIT=qt4
	export QT_API=pyside
	VIRTUALX_COMMAND="nosetests -v" virtualmake
}

python_install_all() {
#	use doc && local HTML_DOCS=( docs/build/html/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
