# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Extension to link to external Doxygen API documentation"
HOMEPAGE="
	https://pypi.org/project/sphinxcontrib-doxylink/
	https://pythonhosted.org/sphinxcontrib-doxylink/
	https://github.com/sphinx-contrib/doxylink/
"
SRC_URI="
	https://github.com/sphinx-contrib/doxylink/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/doxylink-${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/sphinx-1.6[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-3.0.8[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.2[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		app-doc/doxygen
		>=dev-python/testfixtures-6.18.5[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx doc \
	dev-python/sphinx_rtd_theme

python_test() {
	distutils_write_namespace sphinxcontrib
	cd "${T}" || die
	epytest "${S}"/tests
}
