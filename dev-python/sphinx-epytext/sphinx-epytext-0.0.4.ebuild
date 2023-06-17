# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Sphinx epytext extension"
HOMEPAGE="https://pypi.org/project/sphinx-epytext/ https://github.com/jayvdb/sphinx-epytext"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND=">=dev-python/sphinx-1.7.5[${PYTHON_USEDEP}]"
