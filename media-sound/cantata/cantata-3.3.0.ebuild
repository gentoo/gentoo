# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Featureful and configurable Qt client for the music player daemon (MPD)"
HOMEPAGE="https://github.com/nullobsi/cantata"
SRC_URI="https://github.com/nullobsi/cantata/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~x86"
IUSE="cdda cddb http-server mtp musicbrainz replaygain streaming +taglib udisks zeroconf"
REQUIRED_USE="
	cdda? ( taglib udisks || ( cddb musicbrainz ) )
	cddb? ( cdda taglib )
	mtp? ( taglib udisks )
	musicbrainz? ( cdda taglib )
	replaygain? ( taglib )
	udisks? ( taglib )
"

COMMON_DEPEND="
	dev-qt/qtbase:6[dbus,gui,network,sql,sqlite,widgets,xml]
	dev-qt/qtsvg:6
	sys-libs/zlib
	cdda? ( || (
		dev-libs/libcdio-paranoia
		media-sound/cdparanoia
	) )
	cddb? ( media-libs/libcddb )
	mtp? ( media-libs/libmtp:= )
	musicbrainz? ( media-libs/musicbrainz:5= )
	replaygain? (
		media-libs/libebur128:=
		media-sound/mpg123-base
		media-video/ffmpeg:0=
	)
	streaming? ( dev-qt/qtmultimedia:6 )
	taglib? ( >=media-libs/taglib-2:= )
	udisks? ( kde-frameworks/solid:6 )
	zeroconf? ( net-dns/avahi )
"
RDEPEND="${COMMON_DEPEND}
	dev-lang/perl[perl_features_ithreads]
"
DEPEND="${COMMON_DEPEND}
	dev-qt/qtbase:6[concurrent]
"
BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.3.0-rm-vendor.patch
	# https://github.com/nullobsi/cantata/pull/51.patch
	"${FILESDIR}"/${PN}-3.3.0-cdparanoia.patch
	# Fix ODR violations with cddb or udisks enabled
	# https://github.com/nullobsi/cantata/pull/71.patch
	"${FILESDIR}"/${PN}-3.3.0-fix_odr.patch
)

src_prepare() {
	cmake_src_prepare

	# Unbundle 3rd party libs
	# keep knotifications : https://github.com/nullobsi/cantata/commit/719adb5
	rm -r 3rdparty/{ebur128,kcategorizedview,qtsingleapplication,qxt,solid-lite} || die
}

src_configure() {
	local mycmakeargs=(
		# Buggy https://github.com/nullobsi/cantata/commit/18236
		-DENABLE_CATEGORIZED_VIEW=OFF
		-DENABLE_CDPARANOIA=$(usex cdda)
		-DENABLE_CDDB=$(usex cddb)
		-DENABLE_CDIOPARANOIA=$(usex cdda)
		-DENABLE_HTTP_SERVER=$(usex http-server)
		-DENABLE_MTP=$(usex mtp)
		-DENABLE_MUSICBRAINZ=$(usex musicbrainz)
		-DENABLE_FFMPEG=$(usex replaygain)
		-DENABLE_MPG123=$(usex replaygain)
		-DENABLE_HTTP_STREAM_PLAYBACK=$(usex streaming)
		-DENABLE_TAGLIB=$(usex taglib)
		-DENABLE_DEVICES_SUPPORT=$(usex udisks)
		-DENABLE_AVAHI=$(usex zeroconf)
		-DENABLE_REMOTE_DEVICES=OFF
		# use solid/udisks2 instead of udisks
		-DENABLE_UDISKS2=ON
	)

	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst

	has_version media-sound/mpd || \
		elog "An instance of media-sound/mpd, local or remote, is required to set up Cantata."

	if ! has_version app-misc/media-player-info; then
		elog "Install app-misc/media-player-info to enable identification"
		elog "and querying of portable media players"
	fi
}
