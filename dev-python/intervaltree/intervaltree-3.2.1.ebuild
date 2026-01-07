# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Editable interval tree data structure for Python 2 and 3"
HOMEPAGE="
	https://github.com/chaimleib/intervaltree/
	https://pypi.org/project/intervaltree/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

RDEPEND="
	>=dev-python/sortedcontainers-2.4.0[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
