# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils desktop

DESCRIPTION="Colobot is an educational real-time strategy video game featuring 3D graphics"
HOMEPAGE="https://colobot.info/"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/colobot/colobot"
	EGIT_SUBMODULES=()
	inherit git-r3
else
	SRC_URI="https://github.com/colobot/colobot/archive/${PN}-gold-${PV}-alpha.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PN}-gold-${PV}-alpha"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="devbuild test tools doc +openal"

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

src_install() {
	cmake-utils_src_install
	doicon -s 256 desktop/colobot.ico
}
