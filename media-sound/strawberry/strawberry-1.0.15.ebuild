# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic plocale xdg

PLOCALES="ca cs de es es_AR es_ES es_MX fi fr hu id it ja ko nb nl pl pt_BR ru sv uk zh_CN"

DESCRIPTION="Modern music player and library organizer based on Clementine and Qt"
HOMEPAGE="https://www.strawberrymusicplayer.org/"
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/strawberrymusicplayer/strawberry"
	inherit git-r3
else
	SRC_URI="https://github.com/strawberrymusicplayer/strawberry/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~ppc64 x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="cdda debug +gstreamer icu ipod moodbar mtp pulseaudio +udisks vlc"

BDEPEND="
	dev-qt/linguist-tools:5
	sys-devel/gettext
	virtual/pkgconfig
"
COMMON_DEPEND="
	dev-db/sqlite:=
	dev-libs/glib:2
	dev-libs/protobuf:=
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	media-libs/alsa-lib
	media-libs/taglib
	x11-libs/libX11
	cdda? ( dev-libs/libcdio:= )
	gstreamer? (
		media-libs/chromaprint:=
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	icu? ( dev-libs/icu:= )
	ipod? ( media-libs/libgpod )
	moodbar? ( sci-libs/fftw:3.0 )
	mtp? ( media-libs/libmtp )
	pulseaudio? ( media-sound/pulseaudio )
	vlc? ( media-video/vlc )
"
# Note: sqlite driver of dev-qt/qtsql is bundled, so no sqlite use is required; check if this can be overcome someway;
RDEPEND="${COMMON_DEPEND}
	gstreamer? (
		media-plugins/gst-plugins-meta:1.0
		media-plugins/gst-plugins-soup:1.0
		media-plugins/gst-plugins-taglib:1.0
	)
	mtp? ( gnome-base/gvfs[mtp] )
	udisks? ( sys-fs/udisks:2 )
"
DEPEND="${COMMON_DEPEND}
	dev-cpp/gtest
	dev-libs/boost
	dev-qt/qttest:5
"

DOCS=( Changelog README.md )

REQUIRED_USE="
	cdda? ( gstreamer )
	|| ( gstreamer vlc )
"

src_prepare() {
	plocale_find_changes "src/translations" "" ".po"

	cmake_src_prepare
}

src_configure() {
	# spotify is not in portage
	local mycmakeargs=(
		-DBUILD_WERROR=OFF
		# avoid automagically enabling of ccache (bug #611010)
		-DCCACHE_EXECUTABLE=OFF
		-DENABLE_GIO=ON
		-DLINGUAS="$(plocale_get_locales)"
		-DENABLE_AUDIOCD="$(usex cdda)"
		-DENABLE_GSTREAMER="$(usex gstreamer)"
		-DUSE_ICU="$(usex icu)"
		-DENABLE_LIBGPOD="$(usex ipod)"
		-DENABLE_LIBMTP="$(usex mtp)"
		-DENABLE_LIBPULSE="$(usex pulseaudio)"
		-DENABLE_MOODBAR="$(usex moodbar)"
		-DENABLE_MUSICBRAINZ="$(usex gstreamer)"
		-DENABLE_SONGFINGERPRINTING="$(usex gstreamer)"
		-DENABLE_UDISKS2="$(usex udisks)"
		-DENABLE_VLC="$(usex vlc)"
		# Disable until we have qt6 in the tree
		-DWITH_QT6=OFF
	)

	use !debug && append-cppflags -DQT_NO_DEBUG_OUTPUT

	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst

	if use gstreamer ; then
		elog "Note that list of supported formats is controlled by media-plugins/gst-plugins-meta "
		elog "USE flags. You may be interested in setting aac, flac, mp3, ogg or wavpack USE flags "
		elog "depending on your preferences"
	fi
}
