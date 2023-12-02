# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit distutils-r1 pypi

DESCRIPTION="Python bindings for sci-libs/fplll"
HOMEPAGE="https://pypi.org/project/fpylll/
	https://github.com/fplll/fpylll"

# setup.py says "or later"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"
IUSE="test"

RDEPEND="sci-libs/fplll
	dev-python/cysignals[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-python/cython-3[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

src_test(){
	PY_IGNORE_IMPORTMISMATCH=1 distutils-r1_src_test
}
