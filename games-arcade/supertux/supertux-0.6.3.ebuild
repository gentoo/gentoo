# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#: ${CMAKE_MAKEFILE_GENERATOR:=emake}
inherit cmake

MY_PV="${PV/_rc/-rc.}"
MY_P="SuperTux-v${MY_PV}-Source"

DESCRIPTION="A game similar to Super Mario Bros"
HOMEPAGE="https://www.supertux.org"
SRC_URI="https://github.com/SuperTux/${PN}/releases/download/v${MY_PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+ GPL-3+ ZLIB MIT CC-BY-SA-2.0 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="debug"

# =media-libs/libsdl2-2.0.14-r0 can cause supertux binary to move entire
# content of ${HOME} to ${HOME}/.local/share/supertux2/
# DO NOT REMOVE THIS BLOCKER!!! See bug #764959
RDEPEND="
	!=media-libs/libsdl2-2.0.14-r0
	>=dev-games/physfs-3.0
	dev-libs/boost:=[nls]
	media-libs/freetype
	media-libs/glew:=
	media-libs/libpng:0=
	>=media-libs/libsdl2-2.0.1[joystick,video]
	media-libs/libvorbis
	media-libs/openal
	>=media-libs/sdl2-image-2.0.0[png,jpeg]
	>=net-misc/curl-7.21.7
	virtual/opengl
"
DEPEND="${RDEPEND}
	media-libs/glm"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.0-tinygettext.patch
	"${FILESDIR}"/${PN}-0.6.0-{license,icon,obstack}.patch
	"${FILESDIR}"/${PN}-0.6.3-missing-include.patch
)

src_configure() {
	local mycmakeargs=(
		-DWERROR=OFF
		-DINSTALL_SUBDIR_BIN=bin
		-DINSTALL_SUBDIR_DOC=share/doc/${PF}
		-DINSTALL_SUBDIR_SHARE=share/${PN}2
		-DENABLE_SQDBG="$(usex debug)"
		-DUSE_SYSTEM_PHYSFS=ON
		-DIS_SUPERTUX_RELEASE=ON
	)
	cmake_src_configure
}
