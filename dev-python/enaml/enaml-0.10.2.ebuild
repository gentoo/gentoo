# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6} )
inherit distutils-r1 flag-o-matic virtualx

DESCRIPTION="Enthought Tool Suite: framework for writing declarative interfaces"
HOMEPAGE="https://github.com/nucleic/enaml https://pypi.org/project/enaml/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/atom[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/kiwisolver[${PYTHON_USEDEP}]
	dev-python/ply[${PYTHON_USEDEP}]
	dev-python/PyQt5[${PYTHON_USEDEP}]
	dev-python/QtPy[${PYTHON_USEDEP}]
	>=x11-libs/qscintilla-2.10.3
"
DEPEND="${RDEPEND}
	test? (
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
"

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
	export ETS_TOOLKIT=qt5
	VIRTUALX_COMMAND="nosetests -v" virtualmake
}

python_install_all() {
#	use doc && local HTML_DOCS=( docs/build/html/. )
	distutils-r1_python_install_all
}
