# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Pygments lexers for syntax-highlighting IPython code and sessions"
HOMEPAGE="
	https://github.com/ipython/ipython-pygments-lexers
	https://pypi.org/project/ipython-pygments-lexers/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~ppc ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/pygments[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
