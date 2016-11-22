# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="Accelerate module for PyOpenGL"
HOMEPAGE="http://pyopengl.sourceforge.net/ https://pypi.python.org/pypi/PyOpenGL-accelerate"
MY_PN="PyOpenGL-accelerate"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-python/pyopengl[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_P}
