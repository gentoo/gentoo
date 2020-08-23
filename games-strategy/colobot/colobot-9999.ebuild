# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop git-r3 xdg-utils

DESCRIPTION="A real-time strategy game, where you can program your bots"
HOMEPAGE="https://colobot.info/"
EGIT_REPO_URI="https://github.com/colobot/colobot"
EGIT_SUBMODULES=()

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE="devbuild doc +openal test tools"
RESTRICT="!test? ( test )"

# perl for pod2man
BDEPEND="
	app-text/po4a
	dev-lang/perl
	sys-devel/gettext"
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
	openal? ( media-libs/openal )"
RDEPEND="${DEPEND}
	games-strategy/colobot-data"

src_prepare() {
	cmake_src_prepare

	# we need to call it explicitly to help Ninja figure out the deps
	cd desktop || die
	po4a po4a.cfg || die
}

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
	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
