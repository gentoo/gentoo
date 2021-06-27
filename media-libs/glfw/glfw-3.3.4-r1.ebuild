# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib

DESCRIPTION="The Portable OpenGL FrameWork"
HOMEPAGE="https://www.glfw.org/"
SRC_URI="https://github.com/glfw/glfw/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~x86"
IUSE="wayland"

RDEPEND="
	x11-libs/libxkbcommon[${MULTILIB_USEDEP}]
	!wayland? (
		virtual/opengl[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXcursor[${MULTILIB_USEDEP}]
		x11-libs/libXinerama[${MULTILIB_USEDEP}]
		x11-libs/libXrandr[${MULTILIB_USEDEP}]
		x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
	)
	wayland? (
		dev-libs/wayland[${MULTILIB_USEDEP}]
		media-libs/mesa[egl,wayland,${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
	!wayland? (
		x11-base/xorg-proto
		x11-libs/libXi[${MULTILIB_USEDEP}]
	)
	wayland? ( dev-libs/wayland-protocols )
"
BDEPEND="
	wayland? (
		dev-util/wayland-scanner
		kde-frameworks/extra-cmake-modules
	)
"

src_configure() {
	local mycmakeargs=(
		-DGLFW_BUILD_EXAMPLES=no
		-DGLFW_USE_WAYLAND="$(usex wayland)"
		-DBUILD_SHARED_LIBS=1
	)
	cmake-multilib_src_configure
}
