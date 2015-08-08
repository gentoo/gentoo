# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils

DESCRIPTION="The Portable OpenGL FrameWork"
HOMEPAGE="http://www.glfw.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="egl examples"

RDEPEND="x11-libs/libXrandr
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXxf86vm
	x11-libs/libXinerama
	virtual/opengl"
DEPEND="${RDEPEND}
	virtual/glu"

src_configure() {
	local mycmakeargs="
		$(cmake-utils_use egl GLFW_USE_EGL)
		$(cmake-utils_use examples GLFW_BUILD_EXAMPLES)
		-DBUILD_SHARED_LIBS=1
	"
	cmake-utils_src_configure
}
