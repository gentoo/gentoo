# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_REMOVE_MODULES="yes"
CMAKE_REMOVE_MODULES_LIST="FindALSA FindBoost FindFreetype FindGettext FindJpeg FindPng FindTiff FindZ"
inherit cmake-utils desktop gnome2-utils

MY_PN="Performous"
MY_P="${MY_PN}-${PV}"
SONGS_PN="ultrastar-songs"

DESCRIPTION="SingStar GPL clone"
HOMEPAGE="https://performous.org/"
SRC_URI="https://github.com/performous/performous/archive/${PV}.tar.gz -> ${P}.tar.gz
	songs? (
		mirror://sourceforge/performous/${SONGS_PN}-restricted-3.zip
		mirror://sourceforge/performous/${SONGS_PN}-jc-1.zip
		mirror://sourceforge/performous/${SONGS_PN}-libre-3.zip
		mirror://sourceforge/performous/${SONGS_PN}-shearer-1.zip
	)
"

LICENSE="GPL-2 songs? ( CC-BY-NC-SA-2.5 CC-BY-NC-ND-2.5 )
"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="midi songs tools webcam"

RDEPEND="
	dev-cpp/glibmm:2
	dev-cpp/libxmlpp:2.6
	dev-libs/boost[threads(+)]
	dev-libs/glib:2
	dev-libs/libxml2:2
	gnome-base/librsvg:2
	media-gfx/imagemagick:0=
	media-libs/libepoxy
	media-libs/libpng:0=
	media-libs/libsdl2[joystick,video]
	media-libs/portaudio
	sys-libs/zlib
	virtual/ffmpeg
	virtual/glu
	virtual/jpeg:0
	virtual/libintl
	virtual/opengl
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/pango
	midi? ( media-libs/portmidi )
	webcam? ( media-libs/opencv )
"
DEPEND="${RDEPEND}
	sys-apps/help2man
	sys-devel/gettext
	songs? ( app-arch/unzip )
"

DOCS=( docs/{Authors,instruments}.txt )

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-linguas.patch
	"${FILESDIR}"/${P}-nomancompress.patch
	"${FILESDIR}"/${P}-jpeg-9c.patch
	"${FILESDIR}"/${P}-boost-1.70.patch
)

src_prepare() {
	cmake-utils_src_prepare

	sed -i \
		-e "s:@GENTOO_BINDIR@:/usr/bin:" \
		-e '/ Z /s/ Z/ ZLIB/g' \
		-e 's/Z_FOUND/ZLIB_FOUND/g' \
		-e 's/Z_LIBRARIES/ZLIB_LIBRARIES/g' \
		-e 's/Jpeg/JPEG/' \
		-e 's/Png/PNG/' \
		{game,tools}/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_TOOLS=$(usex tools)
		-DENABLE_WEBCAM=$(usex webcam)
		-DENABLE_MIDI=$(usex midi)
		-DCMAKE_VERBOSE_MAKEFILE=TRUE
		-DSHARE_INSTALL="/usr/share/${PN}"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	if use songs ; then
		insinto "/usr/share/${PN}"
		doins -r "${WORKDIR}/songs"
	fi

	newicon -s scalable data/themes/default/icon.svg ${PN}.svg
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
