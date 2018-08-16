# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6} )
inherit distutils-r1

DESCRIPTION="pytest plugin for PyQt4 or PyQt5 applications"
HOMEPAGE="https://pypi.org/project/pytest-qt/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND="
	>=dev-python/pytest-2.7.0[${PYTHON_USEDEP}]
	dev-python/PyQt5[gui,testlib,${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-py3doc-enhanced-theme[${PYTHON_USEDEP}]
	)
"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

# Test make assumptions about Qt environment
RESTRICT="test"

python_compile_all() {
	use doc && sphinx-build -b html docs _build/html
}

python_install_all() {
	use doc && HTML_DOCS=( _build/html/. )
	distutils-r1_python_install_all
}
