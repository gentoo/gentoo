# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="cs de en_GB es fr hu it ja ko pl ru zh_CN"
inherit cmake-utils gnome2-utils l10n qmake-utils xdg

DESCRIPTION="Featureful and configurable Qt client for the music player daemon (MPD)"
HOMEPAGE="https://github.com/CDrummond/cantata"
SRC_URI="https://github.com/CDrummond/cantata/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdda cddb cdio http-server mtp musicbrainz replaygain streaming taglib udisks"
REQUIRED_USE="
	?? ( cdda cdio )
	cdda? ( udisks || ( cddb musicbrainz ) )
	cddb? ( || ( cdio cdda ) taglib )
	cdio? ( udisks || ( cddb musicbrainz ) )
	mtp? ( taglib udisks )
	musicbrainz? ( || ( cdio cdda ) taglib )
	replaygain? ( taglib )
"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	|| ( kde-frameworks/breeze-icons:5 kde-frameworks/oxygen-icons:* )
	sys-libs/zlib
	virtual/libudev:=
	cdda? ( media-sound/cdparanoia )
	cdio? ( dev-libs/libcdio-paranoia )
	cddb? ( media-libs/libcddb )
	mtp? ( media-libs/libmtp )
	musicbrainz? ( media-libs/musicbrainz:5= )
	replaygain? (
		media-libs/libebur128
		media-sound/mpg123
		virtual/ffmpeg
	)
	streaming? ( media-video/vlc:0= )
	taglib? (
		media-libs/taglib[asf(+),mp4(+)]
		media-libs/taglib-extras
		udisks? ( sys-fs/udisks:2 )
	)
"
DEPEND="${RDEPEND}
	dev-qt/qtconcurrent:5
	dev-qt/linguist-tools:5
"

# cantata has no tests
RESTRICT="test"

PATCHES=( "${FILESDIR}/${P}-headers.patch" )

src_prepare() {
	remove_locale() {
		rm "translations/${PN}_${1}".ts || die
	}

	cmake-utils_src_prepare

	# Unbundle 3rd party libs
	rm -r 3rdparty/{ebur128,qtsingleapplication} || die

	l10n_find_plocales_changes "translations" "${PN}_" ".ts"
	l10n_for_each_disabled_locale_do remove_locale
}

src_configure() {
	local mycmakeargs=(
		-DCANTATA_HELPERS_LIB_DIR="$(get_libdir)"
		-DENABLE_CDPARANOIA=$(usex cdda)
		-DENABLE_CDIOPARANOIA=$(usex cdio)
		-DENABLE_CDDB=$(usex cddb)
		-DENABLE_HTTP_SERVER=$(usex http-server)
		-DENABLE_MTP=$(usex mtp)
		-DENABLE_MUSICBRAINZ=$(usex musicbrainz)
		-DLRELEASE_EXECUTABLE="$(qt5_get_bindir)/lrelease"
		-DENABLE_FFMPEG=$(usex replaygain)
		-DENABLE_MPG123=$(usex replaygain)
		-DENABLE_HTTP_STREAM_PLAYBACK=$(usex streaming)
		-DENABLE_TAGLIB=$(usex taglib)
		-DENABLE_TAGLIB_EXTRAS=$(usex taglib)
		-DENABLE_DEVICES_SUPPORT=$(usex udisks)
		-DENABLE_REMOTE_DEVICES=OFF
		-DENABLE_UDISKS2=ON
	)

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
