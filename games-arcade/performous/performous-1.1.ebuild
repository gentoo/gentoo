# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CMAKE_REMOVE_MODULES="yes"
CMAKE_REMOVE_MODULES_LIST="FindALSA FindBoost FindFreetype FindGettext FindJpeg FindPng FindTiff FindZ"
inherit eutils cmake-utils gnome2-utils games

MY_PN=Performous
MY_P=${MY_PN}-${PV}
SONGS_PN=ultrastar-songs

DESCRIPTION="SingStar GPL clone"
HOMEPAGE="https://performous.org/"
SRC_URI="https://github.com/performous/performous/archive/${PV}.tar.gz -> ${P}.tar.gz
	songs? (
		mirror://sourceforge/performous/${SONGS_PN}-restricted-3.zip
		mirror://sourceforge/performous/${SONGS_PN}-jc-1.zip
		mirror://sourceforge/performous/${SONGS_PN}-libre-3.zip
		mirror://sourceforge/performous/${SONGS_PN}-shearer-1.zip
	)"

LICENSE="GPL-2
	songs? (
		CC-BY-NC-SA-2.5
		CC-BY-NC-ND-2.5
	)"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="midi songs tools webcam"

RDEPEND="dev-cpp/glibmm
	dev-cpp/libxmlpp
	media-libs/portaudio
	dev-libs/boost[threads(+)]
	dev-libs/glib:2
	dev-libs/libxml2
	gnome-base/librsvg
	media-gfx/imagemagick
	virtual/jpeg:0
	media-libs/libpng:0
	media-libs/libsdl2[joystick,video]
	virtual/ffmpeg
	virtual/opengl
	virtual/glu
	sys-libs/zlib
	virtual/libintl
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/pango
	media-libs/libepoxy
	midi? ( media-libs/portmidi )
	webcam? ( media-libs/opencv )"
DEPEND="${RDEPEND}
	sys-apps/help2man
	sys-devel/gettext"

src_prepare() {
	cmake-utils_src_prepare
	epatch \
		"${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-linguas.patch
	sed -i \
		-e "s:@GENTOO_BINDIR@:${GAMES_BINDIR}:" \
		-e '/ Z /s/ Z / ZLIB /' \
		-e 's/Jpeg/JPEG/' \
		-e 's/Png/PNG/' \
		game/CMakeLists.txt || die

	strip-linguas -u lang
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable tools TOOLS)
		$(cmake-utils_use_enable webcam WEBCAM)
		$(cmake-utils_use_enable midi MIDI)
		-DCMAKE_VERBOSE_MAKEFILE=TRUE
		-DSHARE_INSTALL="${GAMES_DATADIR}"/${PN}
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	if use songs ; then
		insinto "${GAMES_DATADIR}"/${PN}
		doins -r "${WORKDIR}/songs"
	fi
	dodoc docs/{Authors,instruments}.txt
	newicon -s scalable data/themes/default/icon.svg ${PN}.svg
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
