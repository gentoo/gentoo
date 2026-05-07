# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Small library to dynamically create Python functions"
HOMEPAGE="
	https://pypi.org/project/makefun/
	https://github.com/smarie/python-makefun/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"

BDEPEND="
	dev-python/pkg-resources[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-asyncio )
distutils_enable_tests pytest

python_test() {
	epytest --asyncio-mode=auto
}
