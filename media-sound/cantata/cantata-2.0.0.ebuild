# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PLOCALES="cs de en_GB es hu ko pl ru zh_CN"
inherit cmake-utils gnome2-utils l10n qmake-utils xdg

DESCRIPTION="Featureful and configurable Qt client for the music player daemon (MPD)"
HOMEPAGE="https://github.com/CDrummond/cantata"
SRC_URI="https://github.com/CDrummond/cantata/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="cdda cddb http-server kde mtp musicbrainz qt5 replaygain taglib udisks"
REQUIRED_USE="
	cdda? ( udisks || ( cddb musicbrainz ) )
	cddb? ( cdda taglib )
	mtp? ( taglib udisks )
	musicbrainz? ( cdda taglib )
	qt5? ( !kde )
	replaygain? ( taglib )
"

RDEPEND="
	dev-db/sqlite:3
	sys-libs/zlib
	x11-libs/libX11
	|| ( kde-frameworks/breeze-icons:5 kde-frameworks/oxygen-icons:* )
	cdda? ( media-sound/cdparanoia )
	cddb? ( media-libs/libcddb )
	kde? ( kde-base/kdelibs:4 )
	mtp? ( media-libs/libmtp )
	musicbrainz? ( media-libs/musicbrainz:5 )
	qt5? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtsql:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
	)
	!qt5? (
		dev-libs/qjson
		dev-qt/qtcore:4
		dev-qt/qtdbus:4
		dev-qt/qtgui:4
		dev-qt/qtsql:4
		dev-qt/qtsvg:4
	)
	replaygain? (
		media-libs/libebur128
		media-sound/mpg123
		virtual/ffmpeg
	)
	taglib? (
		media-libs/taglib[asf,mp4]
		media-libs/taglib-extras
		!kde? ( udisks? ( sys-fs/udisks:2 ) )
	)
"
DEPEND="${RDEPEND}
	kde? ( sys-devel/gettext )
	!kde? ( qt5? ( dev-qt/linguist-tools:5 ) )
"

# cantata has no tests
RESTRICT="test"
PATCHES=(
	"${FILESDIR}/${P}-gcc5.patch"
	"${FILESDIR}/${P}-ffmpeg-3.0.patch"
)

src_prepare() {
	cmake-utils_src_prepare

	# Unbundle 3rd party libs
	rm -rf 3rdparty/qtsingleapplication/ || die
	rm -rf 3rdparty/libebur128/ || die
	# qjson ebuild does not support Qt5 yet
	use qt5 || { rm -rf 3rdparty/qjson/ || die ;}
	use kde && { rm -rf 3rdparty/solid-lite/ || die ;}

	l10n_find_plocales_changes 'po' '' '.po'
}

src_configure() {
	local langs="$(l10n_get_locales)"

	local mycmakeargs=(
		-DCANTATA_TRANSLATIONS="${langs// /;}"
		-DENABLE_CDPARANOIA=$(usex cdda)
		-DENABLE_CDDB=$(usex cddb)
		-DENABLE_HTTP_SERVER=$(usex http-server)
		-DENABLE_KDE=$(usex kde)
		-DENABLE_MTP=$(usex mtp)
		-DENABLE_MUSICBRAINZ=$(usex musicbrainz)
		-DENABLE_QT5=$(usex qt5)
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

	if ! use kde; then
		if use qt5; then
			mycmakeargs+=(
				-DLCONVERT_EXECUTABLE="$(qt5_get_bindir)/lconvert"
				-DLRELEASE_EXECUTABLE="$(qt5_get_bindir)/lrelease"
			)
		else
			mycmakeargs+=(
				-DLCONVERT_EXECUTABLE="$(qt4_get_bindir)/lconvert"
				-DLRELEASE_EXECUTABLE="$(qt4_get_bindir)/lrelease"
			)
		fi
	fi

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
