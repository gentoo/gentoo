# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )
inherit distutils-r1

DESCRIPTION="VPython for Jupyter notebook"
HOMEPAGE="http://www.vpython.org/ https://pypi.org/project/vpython/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
DEPEND="dev-python/cython[${PYTHON_USEDEP}]
	dev-python/versioneer[${PYTHON_USEDEP}]
	dev-python/jupyter[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/autobahn[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
