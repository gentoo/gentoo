# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1 virtualx

DESCRIPTION="Accelerate module for PyOpenGL"
HOMEPAGE="
	http://pyopengl.sourceforge.net/
	https://github.com/mcfletch/pyopengl/
	https://pypi.org/project/PyOpenGL-accelerate/"
# pypi archive is missing tests
EGIT_COMMIT="02d11dad9ff18e50db10e975c4756e17bf198464"
SRC_URI="
	https://github.com/mcfletch/pyopengl/archive/${EGIT_COMMIT}.tar.gz
		-> pyopengl-${PV}.gh.tar.gz"
S=${WORKDIR}/pyopengl-${EGIT_COMMIT}/accelerate

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-python/pyopengl[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
