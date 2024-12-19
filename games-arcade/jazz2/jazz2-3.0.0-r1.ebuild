# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake optfeature prefix xdg

DESCRIPTION="Open source reimplementation of Jazz Jackrabbit 2"
HOMEPAGE="https://deat.tk/jazz2/"
SRC_URI="https://github.com/deathkiller/jazz2-native/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-native-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+openal sdl"

DEPEND="
	media-libs/libglvnd
	sys-libs/zlib:=
	openal? (
		media-libs/libopenmpt
		media-libs/openal
	)
	!sdl? ( media-libs/glfw )
	sdl? ( media-libs/libsdl2 )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-system-source.patch
)

src_prepare() {
	cmake_src_prepare
	hprefixify Sources/Shared/Environment.cpp

	# We need to install README.md to a different directory, default
	# src_install will handle that.
	sed -i '/README_INSTALL_DESTINATION/d' cmake/ncine_installation.cmake || die
}

src_configure() {
	local mycmakeargs=(
		-DNCINE_LINUX_PACKAGE="${PN}"

		-DNCINE_DOWNLOAD_DEPENDENCIES=OFF
		-DNCINE_LINKTIME_OPTIMIZATION=OFF
		-DNCINE_STRIP_BINARIES=OFF
		-DNCINE_VERSION_FROM_GIT=OFF
		-DNCINE_WITH_BACKWARD=OFF

		-DNCINE_WITH_GLEW=OFF

		-DNCINE_PREFERRED_BACKEND=$(usex sdl SDL2 GLFW)

		-DNCINE_WITH_AUDIO=$(usex openal)
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "game data unless you want to install it manually" ${CATEGORY}/${PN}-data
}
