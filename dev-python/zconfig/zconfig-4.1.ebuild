# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN="ZConfig"
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Configuration library supporting a hierarchical schema-driven model"
HOMEPAGE="
	https://github.com/zopefoundation/ZConfig/
	https://pypi.org/project/ZConfig/
"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="
	test? (
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/manuel[${PYTHON_USEDEP}]
		dev-python/zope-exceptions[${PYTHON_USEDEP}]
		dev-python/zope-interface[${PYTHON_USEDEP}]
	)
"

DOCS=( CHANGES.rst README.rst )

distutils_enable_tests unittest
distutils_enable_sphinx docs \
	dev-python/sphinxcontrib-programoutput

python_test() {
	eunittest -s src/ZConfig/tests
}
