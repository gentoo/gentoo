# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake optfeature virtualx xdg

DESCRIPTION="Modern music player and library organizer based on Clementine and Qt"
HOMEPAGE="https://www.strawberrymusicplayer.org/"
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/strawberrymusicplayer/strawberry"
	inherit git-r3
else
	SRC_URI="https://github.com/strawberrymusicplayer/strawberry/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="alsa cdda chromaprint +dbus debug discord kde +loudness ipod moodbar mtp +pulseaudio streaming test X"
RESTRICT="!test? ( test )"
REQUIRED_USE="kde? ( dbus )"

COMMON_DEPEND="
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/icu:=
	dev-libs/kdsingleapplication[qt6(+)]
	dev-qt/qtbase:6[concurrent,dbus?,gui,network,ssl,sql,sqlite,widgets,X?]
	media-libs/taglib:=
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0[alsa?]
	alsa? ( media-libs/alsa-lib )
	cdda? ( dev-libs/libcdio:= )
	chromaprint? ( media-libs/chromaprint:= )
	ipod? (
		media-libs/libgpod
		x11-libs/gdk-pixbuf:2
	)
	loudness? ( media-libs/libebur128:= )
	moodbar? ( sci-libs/fftw:3.0= )
	mtp? ( media-libs/libmtp:= )
	pulseaudio? ( media-libs/libpulse )
	X? ( x11-libs/libX11 )
"
# gst-plugins-good provides spectrum plugin for moodbar
RDEPEND="${COMMON_DEPEND}
	media-plugins/gst-plugins-meta:1.0
	moodbar? ( media-libs/gst-plugins-good:1.0 )
	pulseaudio? ( media-plugins/gst-plugins-pulse:1.0 )
"
DEPEND="${COMMON_DEPEND}
	dev-cpp/sparsehash
	dev-libs/boost
	discord? ( dev-libs/rapidjson )
	test? ( dev-cpp/gtest )
"
BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.11-unforce_alsa.patch
)

DOCS=( Changelog README.md )

src_configure() {
	# spotify is not in portage (gst-plugins-rs)
	local mycmakeargs=(
		$(cmake_use_find_package test GTest)
		$(cmake_use_find_package X X11)
		-DBUILD_WERROR=OFF
		# avoid automagically enabling of ccache (bug #611010)
		-DCCACHE_EXECUTABLE=OFF
		-DENABLE_GIO=ON
		-DENABLE_GIO_UNIX=ON
		# depends on sparsehash and taglib
		# enabled by default because stream reading is not optional
		-DENABLE_STREAMTAGREADER=ON
		-DENABLE_ALSA="$(usex alsa)"
		-DENABLE_PULSE="$(usex pulseaudio)"
		-DENABLE_DBUS="$(usex dbus)"
		-DENABLE_MPRIS2="$(usex dbus)"
		-DENABLE_UDISKS2="$(usex dbus)"
		-DENABLE_DEBUG_OUTPUT="$(usex debug)"
		-DENABLE_DISCORD_RPC="$(usex discord)"
		-DENABLE_KGLOBALACCEL_GLOBALSHORTCUTS=$(usex kde)
		-DENABLE_SONGFINGERPRINTING="$(usex chromaprint)"
		-DENABLE_MUSICBRAINZ="$(usex chromaprint)"
		-DENABLE_X11_GLOBALSHORTCUTS="$(usex X)"
		-DENABLE_AUDIOCD="$(usex cdda)"
		-DENABLE_MTP="$(usex mtp)"
		-DENABLE_GPOD="$(usex ipod)"
		-DENABLE_MOODBAR="$(usex moodbar)"
		-DENABLE_EBUR128="$(usex loudness)"
		-DENABLE_SUBSONIC="$(usex streaming)"
		-DENABLE_TIDAL="$(usex streaming)"
		-DENABLE_QOBUZ="$(usex streaming)"
		-DENABLE_SPOTIFY="$(usex streaming)"
	)

	cmake_src_configure
}

src_test() {
	virtx cmake_build run_strawberry_tests
}

pkg_postinst() {
	xdg_pkg_postinst

	use dbus && optfeature "removable device detection" sys-fs/udisks

	elog "Note that list of supported formats is controlled by media-plugins/gst-plugins-meta "
	elog "USE flags. You may be interested in setting aac, flac, mp3, ogg or wavpack USE flags "
	elog "depending on your preferences"
}
