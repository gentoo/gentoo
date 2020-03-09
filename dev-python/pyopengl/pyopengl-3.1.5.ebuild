# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_REQ_USE="tk?"
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

MY_PN="PyOpenGL"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python OpenGL bindings"
HOMEPAGE="http://pyopengl.sourceforge.net/ https://pypi.org/project/PyOpenGL/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
#	mirror://sourceforge/pyopengl/${MY_P}.tar.gz" # broken mirror for this release
LICENSE="BSD"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="tk"

RDEPEND="
	>=media-libs/freeglut-3.2.1
	>=virtual/opengl-7.0
	>=x11-libs/libXi-1.7.10
	>=x11-libs/libXmu-1.1.3
	tk? ( >=dev-tcltk/togl-2.0 )
	>=dev-python/lxml-4.5.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.23.0[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.25.8[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"
