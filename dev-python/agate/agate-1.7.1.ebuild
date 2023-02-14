# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="A Python data analysis library that is optimized for humans instead of machines"
HOMEPAGE="
	https://github.com/wireservice/agate/
	https://pypi.org/project/agate/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="
	>=dev-python/pytimeparse-1.1.5[${PYTHON_USEDEP}]
	>=dev-python/parsedatetime-2.1[${PYTHON_USEDEP}]
	>=dev-python/Babel-2.0[${PYTHON_USEDEP}]
	>=dev-python/isodate-0.5.4[${PYTHON_USEDEP}]
	>=dev-python/pyicu-2.4.2[${PYTHON_USEDEP}]
	>=dev-python/python-slugify-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/leather-0.3.3-r2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/lxml[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme

EPYTEST_DESELECT=(
	# require specific locales
	tests/test_data_types.py::TestDate::test_cast_format_locale
	tests/test_data_types.py::TestDateTime::test_cast_format_locale
)
