# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

MY_P=colobot-gold-${PV/_/-}
DESCRIPTION="A real-time strategy game, where you can program your bots"
HOMEPAGE="
	https://colobot.info/
	https://github.com/colobot/colobot/
"
SRC_URI="https://github.com/colobot/colobot/archive/${MY_P}.tar.gz"
S=${WORKDIR}/${PN}-${MY_P}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="devbuild doc +openal test tools"
RESTRICT="!test? ( test )"

# perl for pod2man
BDEPEND="
	app-text/po4a
	app-text/xmlstarlet
	dev-lang/perl
	sys-devel/gettext
"
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
	openal? ( media-libs/openal )
"
RDEPEND="
	${DEPEND}
	~games-strategy/colobot-data-${PV}
"
DEPEND+="
	test? ( dev-cpp/gtest )
"

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
