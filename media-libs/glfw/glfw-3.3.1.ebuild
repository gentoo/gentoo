# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="The Portable OpenGL FrameWork"
HOMEPAGE="https://www.glfw.org/"
SRC_URI="https://github.com/glfw/glfw/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~x86"
IUSE="examples wayland"

RDEPEND="
	x11-libs/libxkbcommon
	!wayland? (
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-libs/libXxf86vm
	)
	wayland? (
		dev-libs/wayland
		media-libs/mesa[egl,wayland]
	)
"
DEPEND="
	${RDEPEND}
	wayland? ( dev-libs/wayland-protocols )
"
BDEPEND="
	wayland? ( kde-frameworks/extra-cmake-modules )
"

src_configure() {
	local mycmakeargs=(
		-DGLFW_BUILD_EXAMPLES="$(usex examples)"
		-DGLFW_USE_WAYLAND="$(usex wayland)"
		-DBUILD_SHARED_LIBS=1
	)
	cmake_src_configure
}
