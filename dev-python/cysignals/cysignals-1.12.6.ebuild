# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
PYPI_VERIFY_REPO=https://github.com/sagemath/cysignals
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 flag-o-matic pypi

DESCRIPTION="Interrupt and signal handling for Cython"
HOMEPAGE="
	https://github.com/sagemath/cysignals/
	https://pypi.org/project/cysignals/
"

# setup.py had "or later"
LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

BDEPEND="
	>=dev-python/cython-3.0.0[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_configure() {
	# bug 918934
	append-cppflags -D_GENTOO_NO_FORTIFY_SOURCE
	distutils-r1_src_configure
}
