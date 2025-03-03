# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Pygments lexers for syntax-highlighting IPython code and sessions"
HOMEPAGE="
	https://github.com/ipython/ipython-pygments-lexers
	https://pypi.org/project/ipython-pygments-lexers/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~loong ~riscv"

RDEPEND="
	dev-python/pygments[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
