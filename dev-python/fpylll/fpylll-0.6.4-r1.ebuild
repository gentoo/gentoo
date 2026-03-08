# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/fplll/fpylll
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for sci-libs/fplll"
HOMEPAGE="
	https://github.com/fplll/fpylll/
	https://pypi.org/project/fpylll/
"

# setup.py says "or later"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

DEPEND="
	dev-python/cysignals[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=sci-libs/fplll-5.5.0
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=dev-python/cython-3[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test(){
	local -x PY_IGNORE_IMPORTMISMATCH=1
	epytest
}
