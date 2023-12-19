# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=PyOpenGL
PYTHON_REQ_USE="tk?"
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi virtualx

DESCRIPTION="Python OpenGL bindings"
HOMEPAGE="
	https://pyopengl.sourceforge.net/
	https://github.com/mcfletch/pyopengl/
	https://pypi.org/project/PyOpenGL/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"
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
	# https://github.com/mcfletch/pyopengl/commit/b49af26c615236ebc29cf125a8315091482a4a2a
	"${FILESDIR}/${P}-py312.patch"
	# https://github.com/mcfletch/pyopengl/pull/109
	"${FILESDIR}/${P}-pypy3.patch"
)

EPYTEST_DESELECT=(
	# unreliable memory counting test
	tests/test_vbo_memusage.py::test_sf_2980896
)

python_test() {
	nonfatal epytest || die "Tests failed with ${EPYTHON}"
}

src_test() {
	virtx distutils-r1_src_test
}
