# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="VPython for Jupyter notebook"
HOMEPAGE="https://www.vpython.org/ https://pypi.org/project/vpython/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

RDEPEND="
	dev-python/autobahn[${PYTHON_USEDEP}]
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/jupyter[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/versioneer[${PYTHON_USEDEP}]"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"
DEPEND="
	${RDEPEND}
	${BDEPEND}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
