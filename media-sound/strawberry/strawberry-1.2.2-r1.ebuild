# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic xdg

DESCRIPTION="Modern music player and library organizer based on Clementine and Qt"
HOMEPAGE="https://www.strawberrymusicplayer.org/"
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/strawberrymusicplayer/strawberry"
	inherit git-r3
else
	SRC_URI="https://github.com/strawberrymusicplayer/strawberry/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm64 ~ppc64 x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="alsa cdda chromaprint dbus debug kde +loudness ipod moodbar mtp +pulseaudio streaming +udisks X"

BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

#INFO: alsa-lib is always required in linux even if its not built
COMMON_DEPEND="
	dev-db/sqlite:=
	dev-libs/glib:2
	dev-libs/icu:=
	dev-libs/kdsingleapplication[qt6(+)]
	dev-qt/qtbase:6[concurrent,dbus?,gui,network,ssl,sql,sqlite,widgets,X?]
	media-libs/alsa-lib
	media-libs/taglib
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	cdda? ( dev-libs/libcdio:= )
	chromaprint? ( media-libs/chromaprint:= )
	ipod? (
		media-libs/libgpod
		x11-libs/gdk-pixbuf
	)
	moodbar? ( sci-libs/fftw:3.0 )
	mtp? ( media-libs/libmtp )
	loudness? ( media-libs/libebur128 )
	pulseaudio? ( media-libs/libpulse )
"
# Note: sqlite driver of dev-qt/qtsql is bundled, so no sqlite use is required; check if this can be overcome someway;
RDEPEND="${COMMON_DEPEND}
	media-plugins/gst-plugins-meta:1.0
	media-plugins/gst-plugins-taglib
	udisks? ( sys-fs/udisks:2 )
	kde? ( kde-frameworks/kglobalaccel )
"
DEPEND="${COMMON_DEPEND}
	dev-cpp/gtest
	dev-libs/boost
"

DOCS=( Changelog README.md )

REQUIRED_USE="
	|| ( alsa pulseaudio )
"

src_configure() {
	# spotify is not in portage
	local mycmakeargs=(
		$(cmake_use_find_package X X11 )
		-DBUILD_WERROR=OFF
		# avoid automagically enabling of ccache (bug #611010)
		-DCCACHE_EXECUTABLE=OFF
		-DENABLE_GIO=ON
		-DENABLE_GIO_UNIX=ON
		-DENABLE_ALSA="$(usex alsa)"
		-DENABLE_PULSE="$(usex pulseaudio)"
		-DENABLE_DBUS="$(usex dbus)"
		-DENABLE_MPRIS2="$(usex dbus)"
		-DENABLE_KGLOBALACCEL_GLOBALSHORTCUTS=$(usex kde)
		-DENABLE_SONGFINGERPRINTING="$(usex chromaprint)"
		-DENABLE_MUSICBRAINZ="$(usex chromaprint)"
		-DENABLE_X11_GLOBALSHORTCUTS="$(usex X)"
		-DENABLE_AUDIOCD="$(usex cdda)"
		-DENABLE_MTP="$(usex mtp)"
		-DENABLE_GPOD="$(usex ipod)"
		-DENABLE_MOODBAR="$(usex moodbar)"
		-DENABLE_UDISKS2="$(usex udisks)"
		-DENABLE_EBUR128="$(usex loudness)"
		-DENABLE_SUBSONIC="$(usex streaming)"
		-DENABLE_TIDAL="$(usex streaming)"
		-DENABLE_QOBUZ="$(usex streaming)"
		-DENABLE_SPOTIFY="$(usex streaming)"
	)

	use !debug && append-cppflags -DQT_NO_DEBUG_OUTPUT

	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "Note that list of supported formats is controlled by media-plugins/gst-plugins-meta "
	elog "USE flags. You may be interested in setting aac, flac, mp3, ogg or wavpack USE flags "
	elog "depending on your preferences"
}
