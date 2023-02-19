# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_REQ_USE="tk?"
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi virtualx

DESCRIPTION="Python OpenGL bindings"
HOMEPAGE="
	https://pyopengl.sourceforge.net/
	https://github.com/mcfletch/pyopengl/
	https://pypi.org/project/PyOpenGL/
"
SRC_URI="
	$(pypi_sdist_url --no-normalize PyOpenGL)
	https://github.com/mcfletch/pyopengl/commit/2d2457b4d565bce1c58b76b427e1f9027e8b4bcc.patch
		-> ${P}-glut-font-egl.patch
"
S="${WORKDIR}/PyOpenGL-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="tk"

RDEPEND="
	media-libs/freeglut
	virtual/opengl
	x11-libs/libXi
	x11-libs/libXmu
	tk? ( dev-tcltk/togl )
"
DEPEND="
	${RDEPEND}
"

# The tests need an X server with the GLX extension. Software rendering
# under Xvfb works but only with llvmpipe, not softpipe or swr.
BDEPEND="
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pygame[${PYTHON_USEDEP},opengl,X]
		!prefix? (
			media-libs/mesa[llvm]
			x11-base/xorg-server[-minimal,xorg]
		)
	)
"

distutils_enable_tests pytest

PATCHES=(
	"${DISTDIR}/${P}-glut-font-egl.patch"
)

src_test() {
	virtx distutils-r1_src_test
}
