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

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/epydoc-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/genshi-0.7.3[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.18.2[${PYTHON_USEDEP}]
	>=dev-python/pydocstylei-5.0.2[${PYTHON_USEDEP}]
	>=dev-python/pyopengl-3.1.5[${PYTHON_USEDEP}]
	>=dev-python/six-1.14.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"
