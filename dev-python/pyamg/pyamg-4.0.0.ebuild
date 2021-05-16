# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=bdepend
PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Algebraic multigrid solvers in Python"
HOMEPAGE="https://pyamg.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pybind11[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]"
# cannot be enabled by "distutils_enable_tests pytest"
BDEPEND="test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

distutils_enable_tests setup.py

PATCHES=( "${FILESDIR}"/${P}-test.patch )
