# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PLOCALES="cs de en_GB es fr hu ko pl ru zh_CN"
inherit cmake-utils gnome2-utils l10n qmake-utils xdg

DESCRIPTION="Featureful and configurable Qt client for the music player daemon (MPD)"
HOMEPAGE="https://github.com/CDrummond/cantata"
SRC_URI="https://github.com/CDrummond/cantata/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdda cddb http-server mtp musicbrainz replaygain taglib udisks"
REQUIRED_USE="
	cdda? ( udisks || ( cddb musicbrainz ) )
	cddb? ( cdda taglib )
	mtp? ( taglib udisks )
	musicbrainz? ( cdda taglib )
	replaygain? ( taglib )
"

RDEPEND="
	dev-db/sqlite:3
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	sys-libs/zlib
	|| ( kde-frameworks/breeze-icons:5 kde-frameworks/oxygen-icons:* )
	cdda? ( media-sound/cdparanoia )
	cddb? ( media-libs/libcddb )
	mtp? ( media-libs/libmtp )
	musicbrainz? ( media-libs/musicbrainz:5 )
	replaygain? (
		media-libs/libebur128
		media-sound/mpg123
		virtual/ffmpeg
	)
	taglib? (
		media-libs/taglib[asf(+),mp4(+)]
		media-libs/taglib-extras
		udisks? ( sys-fs/udisks:2 )
	)
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
"

# cantata has no tests
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${P}-mpris-true.patch"
	"${FILESDIR}/${P}-mpris-plasma57.patch"
	"${FILESDIR}/${P}-qt5-no-X11.patch"
)

src_prepare() {
	cmake-utils_src_prepare

	# Unbundle 3rd party libs
	rm -rf 3rdparty/qtsingleapplication/ || die
	rm -rf 3rdparty/libebur128/ || die
	# qjson ebuild does not support Qt5 yet
	rm -rf 3rdparty/qjson/ || die

	l10n_find_plocales_changes 'po' '' '.po'
}

src_configure() {
	local langs="$(l10n_get_locales)"

	local mycmakeargs=(
		-DCANTATA_HELPERS_LIB_DIR="$(get_libdir)"
		-DCANTATA_TRANSLATIONS="${langs// /;}"
		-DENABLE_CDPARANOIA=$(usex cdda)
		-DENABLE_CDDB=$(usex cddb)
		-DENABLE_HTTP_SERVER=$(usex http-server)
		-DENABLE_MTP=$(usex mtp)
		-DENABLE_MUSICBRAINZ=$(usex musicbrainz)
		-DENABLE_QT5=ON
		-DLCONVERT_EXECUTABLE="$(qt5_get_bindir)/lconvert"
		-DLRELEASE_EXECUTABLE="$(qt5_get_bindir)/lrelease"
		-DENABLE_FFMPEG=$(usex replaygain)
		-DENABLE_MPG123=$(usex replaygain)
		-DENABLE_TAGLIB=$(usex taglib)
		-DENABLE_TAGLIB_EXTRAS=$(usex taglib)
		-DENABLE_DEVICES_SUPPORT=$(usex udisks)
		-DENABLE_HTTP_STREAM_PLAYBACK=OFF
		-DENABLE_REMOTE_DEVICES=OFF
		-DENABLE_UDISKS2=ON
		-DUSE_SYSTEM_MENU_ICON=OFF
	)
#	-DENABLE_KDE=$(usex kde)	# not yet ported to KF5

	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
	xdg_pkg_preinst
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_pkg_postrm
}
