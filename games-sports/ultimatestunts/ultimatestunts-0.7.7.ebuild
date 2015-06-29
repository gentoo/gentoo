# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-sports/ultimatestunts/ultimatestunts-0.7.7.ebuild,v 1.4 2015/06/29 18:41:29 mr_bones_ Exp $

EAPI=5
inherit eutils flag-o-matic versionator games

MY_P=${PN}-srcdata-$(replace_all_version_separators)1
DESCRIPTION="Remake of the famous Stunts game"
HOMEPAGE="http://www.ultimatestunts.nl/"
SRC_URI="mirror://sourceforge/ultimatestunts/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND="media-libs/libsdl[joystick,opengl,video]
	media-libs/sdl-image
	>=media-libs/openal-1
	media-libs/libvorbis
	media-libs/freealut
	virtual/opengl
	virtual/glu
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	sys-devel/gettext"

S=${WORKDIR}/${MY_P}

src_prepare() {
	esvn_clean
	epatch "${FILESDIR}"/${P}-paths.patch \
		"${FILESDIR}"/${P}-gcc-4.7.patch
	append-cppflags $(sdl-config --cflags)
}

src_configure() {
	egamesconf \
		--with-openal \
		$(use_enable nls)
}

src_compile() {
	emake -C trackedit libtrackedit.a
	emake
}

src_install() {
	default
	newicon data/cars/diablo/steer.png ${PN}.png
	make_desktop_entry ustunts "Ultimate Stunts"
	prepgamesdirs
}
