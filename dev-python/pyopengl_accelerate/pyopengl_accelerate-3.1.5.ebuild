# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Accelerate module for PyOpenGL"
HOMEPAGE="http://pyopengl.sourceforge.net/ https://pypi.org/project/PyOpenGL-accelerate/"
MY_PN="PyOpenGL-accelerate"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

# pypi tarball doesn't include tests and they need a gpu to run,
# github repo doesn't include tags and the pypi tarball is a subset of what's in that repo.
RESTRICT="test"

RDEPEND="
	>=dev-python/genshi-0.7.3-r1[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.18.2[${PYTHON_USEDEP}]
	>=dev-python/pydocstyle-5.0.2[${PYTHON_USEDEP}]
	>=dev-python/pyopengl-3.1.5[${PYTHON_USEDEP}]
	>=dev-python/six-1.14.0[${PYTHON_USEDEP}]
	>=dev-python/sphinx-2.0.1-r1[${PYTHON_USEDEP}]
	>=dev-python/sphinx-epytext-0.0.4[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"
