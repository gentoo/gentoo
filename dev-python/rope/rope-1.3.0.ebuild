# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Python refactoring library"
HOMEPAGE="
	https://pypi.org/project/rope/
	https://github.com/python-rope/rope/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm64"
IUSE="doc"

RDEPEND="
	dev-python/pytoolconfig[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/build[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# our venv style confuses this comparison
	ropetest/contrib/autoimport/utilstest.py::test_get_package_source_typing
	ropetest/contrib/autoimport/utilstest.py::test_get_package_tuple_typing
	ropetest/contrib/autoimport/utilstest.py::test_get_package_tuple_compiled
)
