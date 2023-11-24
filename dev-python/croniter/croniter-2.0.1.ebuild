# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python module to provide iteration for datetime object"
HOMEPAGE="
	https://github.com/kiorky/croniter/
	https://pypi.org/project/croniter/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"

RDEPEND="
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/tzlocal[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
