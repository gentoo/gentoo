# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Interrupt and signal handling for Cython"
HOMEPAGE="
	https://github.com/sagemath/cysignals/
	https://pypi.org/project/cysignals/
"

# setup.py has "or later"
LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

BDEPEND="
	>=dev-python/cython-3.0.0[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
