# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Adds read support for Excel files (xls and xlsx) to agate"
HOMEPAGE="
	https://github.com/wireservice/agate-excel/
	https://pypi.org/project/agate-excel/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/agate-1.5.0[${PYTHON_USEDEP}]
	dev-python/olefile[${PYTHON_USEDEP}]
	>=dev-python/openpyxl-2.3.0[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/xlrd-0.9.4[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/lxml[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
