# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils desktop xdg-utils

DESCRIPTION="Colobot is an educational real-time strategy video game featuring 3D graphics"
HOMEPAGE="https://colobot.info/"
SRC_URI="https://github.com/colobot/colobot/archive/${PN}-gold-${PV}-alpha.tar.gz"
S="${WORKDIR}/${PN}-${PN}-gold-${PV}-alpha"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
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
	cmake-utils_src_prepare

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
	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
