# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# upstream CMakeLists.txt are buggy
CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake-utils desktop git-r3 xdg-utils

DESCRIPTION="Colobot is an educational real-time strategy video game featuring 3D graphics"
HOMEPAGE="https://colobot.info/"
EGIT_REPO_URI="https://github.com/colobot/colobot"
EGIT_SUBMODULES=()

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="devbuild doc +openal test tools"
RESTRICT="!test? ( test )"

DEPEND="
	dev-games/physfs
	dev-libs/boost:=
	media-libs/glew:0
	media-libs/libogg
	media-libs/libpng:0=
	media-libs/libsdl2:=
	media-libs/libsndfile:=
	media-libs/libvorbis:=
	media-libs/sdl2-image
	media-libs/sdl2-ttf
	media-sound/vorbis-tools
	sys-devel/gettext
	openal? ( media-libs/openal )"
RDEPEND="${DEPEND}
	games-strategy/colobot-data"

src_configure() {
	local mycmakeargs=(
		-DDEV_BUILD=$(usex devbuild)
		-DTESTS=$(usex test)
		-DTOOLS=$(usex tools)
		-DINSTALL_DOCS=$(usex doc)
		-DOPENAL_SOUND=$(usex openal)
		-DCOLOBOT_INSTALL_BIN_DIR="${EPREFIX}"/usr/bin
		-DCOLOBOT_INSTALL_LIB_DIR="${EPREFIX}"/usr/$(get_libdir)
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
