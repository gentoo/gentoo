# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Extension to link to external Doxygen API documentation"
HOMEPAGE="https://pypi.org/project/sphinxcontrib-doxylink/ https://pythonhosted.org/sphinxcontrib-doxylink/ https://github.com/sphinx-contrib/doxylink"
SRC_URI="https://github.com/sphinx-contrib/doxylink/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/doxylink-${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/sphinx-1.0[${PYTHON_USEDEP}]
	dev-python/namespace-sphinxcontrib[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		app-doc/doxygen
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/testfixtures[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx doc

python_install_all() {
	distutils-r1_python_install_all
	find "${ED}" -name '*.pth' -delete || die
}
