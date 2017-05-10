# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="Pure-Python implementation of the Git file formats and protocols"
HOMEPAGE="https://github.com/jelmer/dulwich/ https://pypi.python.org/pypi/dulwich"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc examples test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/gevent[${PYTHON_USEDEP}]
		dev-python/geventhttpclient[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/python-fastimport[${PYTHON_USEDEP}]
	)"

DISTUTILS_IN_SOURCE_BUILD=1

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	emake check
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
