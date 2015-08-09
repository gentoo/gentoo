# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils cmake-utils games

DESCRIPTION="A fully free and open source MMORPG game client"
HOMEPAGE="http://manasource.org/"
SRC_URI="http://manasource.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="nls opengl"

RDEPEND="!=games-rpg/tmw-0.5.2
	>=dev-games/physfs-1.0.0
	dev-libs/libxml2
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-image[png]
	media-libs/sdl-net
	media-libs/sdl-ttf
	net-misc/curl
	sys-libs/zlib
	media-libs/libpng:0
	media-fonts/dejavu
	>=dev-games/guichan-0.8.1[sdl]
	media-libs/libsdl[X,opengl?,video]
	media-libs/sdl-gfx
	x11-libs/libX11
	nls? ( virtual/libintl )
	opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

DOCS=( AUTHORS ChangeLog NEWS README )
PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-Fix-missing-virtual-destructors-and-guichan-use.patch
	"${FILESDIR}"/${P}-Trick-gcc-into-importing-C99-stdint.h-when-C-11-is-n.patch
	"${FILESDIR}"/${P}-Import-cstdint-for-int64_t.patch
	)

src_prepare() {
	epatch ${PATCHES[@]}
	epatch_user

	if [[ ${LINGUAS+set} ]]; then
		for lang in $(grep -v ^# po/LINGUAS); do
			has $lang $LINGUAS || sed -i "s:^${lang}:#${lang}:" po/LINGUAS
		done
	fi
}

src_compile() {
	cmake-utils_src_compile
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with opengl)
		$(cmake-utils_use_enable nls)
		-DPKG_DATADIR="${GAMES_DATADIR}/${PN}"
		-DPKG_BINDIR="${GAMES_BINDIR}"
		-DWITH_BUNDLEDHEADERS=OFF
		-DENABLE_CPP0X=OFF
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dosym /usr/share/fonts/dejavu/DejaVuSans-Bold.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/dejavusans-bold.ttf
	dosym /usr/share/fonts/dejavu/DejaVuSans.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/dejavusans.ttf
	dosym /usr/share/fonts/dejavu/DejaVuSansMono.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/dejavusans-mono.ttf
	insinto "${GAMES_DATADIR}"/${PN}/data
	prepgamesdirs
}
