# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/wireservice/agate
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A Python data analysis library that is optimized for humans instead of machines"
HOMEPAGE="
	https://github.com/wireservice/agate/
	https://pypi.org/project/agate/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~arm64-macos ~x64-macos"

RDEPEND="
	>=dev-python/pytimeparse-1.1.5[${PYTHON_USEDEP}]
	>=dev-python/parsedatetime-2.1[${PYTHON_USEDEP}]
	>=dev-python/babel-2.0[${PYTHON_USEDEP}]
	>=dev-python/isodate-0.5.4[${PYTHON_USEDEP}]
	>=dev-python/pyicu-2.4.2[${PYTHON_USEDEP}]
	>=dev-python/python-slugify-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/leather-0.3.3-r2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/cssselect-0.9.1[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/furo

EPYTEST_DESELECT=(
	# require specific locales
	tests/test_data_types.py::TestDate::test_cast_format_locale
	tests/test_data_types.py::TestDateTime::test_cast_format_locale
)

PATCHES=(
	# https://github.com/wireservice/agate/pull/796
	"${FILESDIR}/${P}-stray-files.patch"
)
