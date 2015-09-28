# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games

DESCRIPTION="OpenSource 2D MMORPG client for Evol Online and The Mana World"
HOMEPAGE="http://manaplus.evolonline.org"
SRC_URI="http://download.evolonline.org/manaplus/download/${PV}/manaplus-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="nls opengl"

RDEPEND="
	>=dev-games/physfs-1.0.0
	dev-libs/libxml2
	media-libs/libpng:0=
	media-libs/libsdl2[X,opengl?,video]
	media-libs/sdl2-gfx
	media-libs/sdl2-image[png]
	media-libs/sdl2-mixer[vorbis]
	media-libs/sdl2-net
	media-libs/sdl2-ttf
	net-misc/curl
	sys-libs/zlib
	x11-libs/libX11
	x11-misc/xdg-utils
	x11-apps/xmessage
	media-fonts/dejavu
	media-fonts/wqy-microhei
	media-fonts/liberation-fonts
	media-fonts/mplus-outline-fonts
	nls? ( virtual/libintl )
	opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	sed -i \
		-e '/^SUBDIRS/s/fonts//' \
		data/Makefile.in || die
}

src_configure() {
	CONFIG_SHELL=/bin/bash \
	egamesconf \
		--with-sdl2 \
		--without-internalsdlgfx \
		--localedir=/usr/share/locale \
		--prefix="/usr" \
		--bindir="${GAMES_BINDIR}" \
		$(use_with opengl) \
		$(use_enable nls)
}

src_install() {
	default
	dosym /usr/share/fonts/dejavu/DejaVuSans-Bold.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/dejavusans-bold.ttf
	dosym /usr/share/fonts/dejavu/DejaVuSansMono-Bold.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/dejavusansmono-bold.ttf
	dosym /usr/share/fonts/dejavu/DejaVuSansMono.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/dejavusansmono.ttf
	dosym /usr/share/fonts/dejavu/DejaVuSans.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/dejavusans.ttf
	dosym /usr/share/fonts/liberation-fonts/LiberationSans-Bold.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/liberationsans-bold.ttf
	dosym /usr/share/fonts/liberation-fonts/LiberationMono-Bold.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/liberationsansmono-bold.ttf
	dosym /usr/share/fonts/liberation-fonts/LiberationMono-Regular.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/liberationsansmono.ttf
	dosym /usr/share/fonts/liberation-fonts/LiberationSans-Regular.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/liberationsans.ttf
	dosym /usr/share/fonts/wqy-microhei/wqy-microhei.ttc "${GAMES_DATADIR}"/${PN}/data/fonts/wqy-microhei.ttf
	dosym /usr/share/fonts/mplus-outline-fonts/mplus-1p-bold.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/mplus-1p-bold.ttf
	dosym /usr/share/fonts/mplus-outline-fonts/mplus-1p-regular.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/mplus-1p-regular.ttf

	prepgamesdirs
}
