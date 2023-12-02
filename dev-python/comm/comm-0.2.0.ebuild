# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Jupyter Python Comm implementation, for usage in ipykernel, xeus-python"
HOMEPAGE="
	https://github.com/ipython/comm/
	https://pypi.org/project/comm/
"
# no tests in sdist, as of 0.1.3
SRC_URI="
	https://github.com/ipython/comm/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos ~x64-macos"

RDEPEND="
	>=dev-python/traitlets-4[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
