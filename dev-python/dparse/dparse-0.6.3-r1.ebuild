# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="A parser for Python dependency files"
HOMEPAGE="
	https://github.com/pyupio/dparse
	https://pypi.org/project/dparse/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest

BDEPEND="
	test? (
		dev-python/pipenv[${PYTHON_USEDEP}]
	)
"

PDEPEND="
	dev-python/pipenv[${PYTHON_USEDEP}]
"
