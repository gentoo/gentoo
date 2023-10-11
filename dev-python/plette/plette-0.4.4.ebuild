# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="PythonFinder: Cross Platform Search Tool for Finding Pythons"
HOMEPAGE="
	https://github.com/sarugaku/plette
	https://pypi.org/project/plette/
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/cerberus[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
