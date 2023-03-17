# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Jupyter Python Comm implementation, for usage in ipykernel, xeus-python"
HOMEPAGE="
	https://github.com/ipython/comm/
	https://pypi.org/project/comm/
"
SRC_URI="
	https://github.com/ipython/comm/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/traitlets-5.3[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
