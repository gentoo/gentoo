# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/wireservice/agate-excel
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Adds read support for Excel files (xls and xlsx) to agate"
HOMEPAGE="
	https://github.com/wireservice/agate-excel/
	https://pypi.org/project/agate-excel/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64-macos ~x64-macos"

RDEPEND="
	>=dev-python/agate-1.5.0[${PYTHON_USEDEP}]
	dev-python/olefile[${PYTHON_USEDEP}]
	>=dev-python/openpyxl-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/xlrd-0.9.4[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/lxml[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
