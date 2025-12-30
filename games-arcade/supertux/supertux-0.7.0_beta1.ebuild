# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_QA_COMPAT_SKIP=1
inherit cmake xdg

DESCRIPTION="A run n' jump platforming game featuring Tux the penguin"
HOMEPAGE="https://www.supertux.org"

MY_PV="${PV/_rc/-rc.}"
MY_PV="${MY_PV/_beta/-beta.}"
MY_P="SuperTux-v${MY_PV}-Source"

SRC_URI="https://github.com/SuperTux/${PN}/releases/download/v${MY_PV}/${MY_P}.tar.gz"
KEYWORDS="~amd64 ~arm64 ~x86"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+ GPL-3+ ZLIB MIT CC-BY-SA-2.0 CC-BY-SA-3.0"
SLOT="0"
IUSE="debug +opengl test"
RESTRICT="!test? ( test )"

# NOTE: curl is not a required dependency, but there is no compile option
# at the moment to turn it off. Should hopefully be in by beta.2/release.
RDEPEND="
	>=dev-games/physfs-3.0
	dev-libs/libfmt
	media-libs/freetype
	media-libs/libpng:0=
	>=media-libs/libsdl2-2.0.1[joystick,video]
	media-libs/libvorbis
	media-libs/openal
	>=media-libs/sdl2-ttf-2.0.15
	>=media-libs/sdl2-image-2.0.0[png,jpeg]
	>=net-misc/curl-7.21.7
	opengl? (
		media-libs/glew:=
		virtual/opengl
	)
"
DEPEND="${RDEPEND}
	media-libs/glm"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DINSTALL_SUBDIR_BIN=bin
		-DINSTALL_SUBDIR_DOC=share/doc/${PF}
		-DINSTALL_SUBDIR_SHARE=share/${PN}2
		-DENABLE_SQDBG="$(usex debug)"
		# SuperTux uses its own modified (simple)squirrel fork anyway, so it's
		# unlikely that anyone will link with it. It's also prone to a conflict
		# if one were to bundle simplesquirrel separately (libsimplesquirrel.so)
		-DUSE_STATIC_SIMPLESQUIRREL=ON
		-DUSE_SYSTEM_SDL2_TTF=ON
		-DIS_SUPERTUX_RELEASE=ON
		-DENABLE_OPENGL="$(usex opengl)"
		-DBUILD_TESTING="$(usex test)"
		# CMake croaks due to missing .git on the beta sources (yes), so
		# just manually set the version, as it would do otherwise anyway
		# from the git tag.
		-DSUPERTUX_PACKAGE_VERSION="v${MY_PV}"
		-DSUPERTUX_VERSION_STRING="v${MY_PV}"
	)

	cmake_src_configure
}
