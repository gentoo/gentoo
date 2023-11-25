# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )
inherit distutils-r1 pypi

DESCRIPTION="Editable interval tree data structure for Python 2 and 3"
HOMEPAGE="https://pypi.org/project/intervaltree/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"

RDEPEND="dev-python/sortedcontainers[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
