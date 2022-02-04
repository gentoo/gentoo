# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="VPython for Jupyter notebook"
HOMEPAGE="https://www.vpython.org/ https://pypi.org/project/vpython/"
SRC_URI="https://github.com/${PN}/${PN}-jupyter/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-jupyter-${PV}"

RDEPEND="
	>=dev-python/autobahn-18.8.2[${PYTHON_USEDEP}]
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/jupyter[${PYTHON_USEDEP}]
	dev-python/jupyter-server-proxy[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/versioneer[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	${BDEPEND}
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"
PATCHES="${FILESDIR}/${P}-fix-python310-detection.patch"

distutils_enable_tests pytest
