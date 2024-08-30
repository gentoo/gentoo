# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="A free OpenGL utility toolkit, the open-sourced alternative to the GLUT library"
HOMEPAGE="https://freeglut.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

# enabling GLES support seems to cause build failures
RDEPEND=">=virtual/glu-9.0-r1[${MULTILIB_USEDEP}]
	>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXi-1.7.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXrandr-1.4.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXxf86vm-1.1.3[${MULTILIB_USEDEP}]"
# gles? ( media-libs/mesa[egl(+),gles1,gles2,${MULTILIB_USEDEP}] )
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
#		"-DOpenGL_GL_PREFERENCE=GLVND" # bug 721006
		"-DFREEGLUT_GLES=OFF"
		"-DFREEGLUT_BUILD_DEMOS=OFF"
		"-DFREEGLUT_BUILD_STATIC_LIBS=OFF"
	)
#	$(cmake-utils_use gles FREEGLUT_GLES)
	cmake-multilib_src_configure
}

multilib_src_install() {
	cmake_src_install
	cp "${ED}"/usr/$(get_libdir)/pkgconfig/{,free}glut.pc || die
}
