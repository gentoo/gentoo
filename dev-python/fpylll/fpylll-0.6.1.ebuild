# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for sci-libs/fplll"
HOMEPAGE="
	https://github.com/fplll/fpylll/
	https://pypi.org/project/fpylll/
"

# setup.py says "or later"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"
IUSE="test"

DEPEND="
	dev-python/cysignals[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/fplll
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=dev-python/cython-3[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}/${P}-testfix.patch" )

distutils_enable_tests pytest

python_test(){
	local -x PY_IGNORE_IMPORTMISMATCH=1
	epytest
}
