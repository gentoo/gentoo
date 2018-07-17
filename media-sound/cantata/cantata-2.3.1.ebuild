# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="cs da de en_GB es fr hu it ja ko pl ru zh_CN"
inherit cmake-utils gnome2-utils l10n qmake-utils xdg-utils

DESCRIPTION="Featureful and configurable Qt client for the music player daemon (MPD)"
HOMEPAGE="https://github.com/CDrummond/cantata"
SRC_URI="https://github.com/CDrummond/cantata/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdda cddb cdio http-server mtp musicbrainz replaygain streaming taglib udisks zeroconf"
REQUIRED_USE="
	?? ( cdda cdio )
	cdda? ( udisks || ( cddb musicbrainz ) )
	cddb? ( || ( cdio cdda ) taglib )
	cdio? ( udisks || ( cddb musicbrainz ) )
	mtp? ( taglib udisks )
	musicbrainz? ( || ( cdio cdda ) taglib )
	replaygain? ( taglib )
"

COMMON_DEPEND="
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
	cddb? ( media-libs/libcddb )
	cdio? ( dev-libs/libcdio-paranoia )
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
		udisks? ( sys-fs/udisks:2 )
	)
	zeroconf? ( net-dns/avahi )
"
RDEPEND="${COMMON_DEPEND}
	dev-lang/perl[ithreads]
"
DEPEND="${COMMON_DEPEND}
	dev-qt/qtconcurrent:5
	dev-qt/linguist-tools:5
"

# cantata has no tests
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${PN}-2.2.0-headers.patch"
)

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
		-DENABLE_CDDB=$(usex cddb)
		-DENABLE_CDIOPARANOIA=$(usex cdio)
		-DENABLE_HTTP_SERVER=$(usex http-server)
		-DENABLE_MTP=$(usex mtp)
		-DENABLE_MUSICBRAINZ=$(usex musicbrainz)
		-DLRELEASE_EXECUTABLE="$(qt5_get_bindir)/lrelease"
		-DENABLE_FFMPEG=$(usex replaygain)
		-DENABLE_MPG123=$(usex replaygain)
		-DENABLE_HTTP_STREAM_PLAYBACK=$(usex streaming)
		-DENABLE_TAGLIB=$(usex taglib)
		-DENABLE_DEVICES_SUPPORT=$(usex udisks)
		-DENABLE_AVAHI=$(usex zeroconf)
		-DENABLE_REMOTE_DEVICES=OFF
		-DENABLE_UDISKS2=ON
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update

	has_version media-sound/mpd || \
		elog "An instance of media-sound/mpd, local or remote, is required to set up Cantata."

	if ! has_version app-misc/media-player-info; then
		elog "Install app-misc/media-player-info to enable identification"
		elog "and querying of portable media players"
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
