# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Read resources from Python packages"
HOMEPAGE="
	https://github.com/python/importlib_resources/
	https://pypi.org/project/importlib-resources/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		>=dev-python/jaraco-test-5.4[${PYTHON_USEDEP}]
		>=dev-python/zipp-3.17[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest
