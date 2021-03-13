# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic l10n virtualx xdg

PLOCALES="cs de es fr hu id it ko nb pl ru sv"

DESCRIPTION="Modern music player and library organizer based on Clementine and Qt"
HOMEPAGE="https://www.strawbs.org/"
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/jonaski/strawberry.git"
	inherit git-r3
else
	SRC_URI="https://github.com/jonaski/strawberry/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~ppc64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="cdda +dbus debug +gstreamer ipod mtp pulseaudio +udisks vlc"

REQUIRED_USE="
	udisks? ( dbus )
"

BDEPEND="
	dev-qt/linguist-tools:5
	sys-devel/gettext
	virtual/pkgconfig
"
COMMON_DEPEND="
	app-crypt/qca:2[qt5(+)]
	dev-db/sqlite:=
	dev-libs/glib:2
	dev-libs/libxml2
	dev-libs/protobuf:=
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtwidgets:5
	media-libs/alsa-lib
	media-libs/chromaprint:=
	>=media-libs/libmygpo-qt-1.0.9[qt5(+)]
	>=media-libs/taglib-1.11.1_p20181028
	sys-libs/zlib
	virtual/glu
	x11-libs/libX11
	cdda? ( dev-libs/libcdio:= )
	dbus? ( dev-qt/qtdbus:5 )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	ipod? ( >=media-libs/libgpod-0.8.0 )
	mtp? ( >=media-libs/libmtp-1.0.0 )
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
	>=dev-cpp/gtest-1.8.0
	dev-libs/boost
	dev-qt/qtopengl:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
"

DOCS=( Changelog README.md )

REQUIRED_USE="
	|| ( gstreamer vlc )
"

src_prepare() {
	l10n_find_plocales_changes "src/translations" "" ".po"

	cmake_src_prepare
}

src_configure() {
	# spotify is not in portage
	local mycmakeargs=(
		-DBUILD_WERROR=OFF
		# avoid automagically enabling of ccache (bug #611010)
		-DCCACHE_EXECUTABLE=OFF
		-DENABLE_GIO=ON
		-DLINGUAS="$(l10n_get_locales)"
		-DENABLE_AUDIOCD="$(usex cdda)"
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5DBus=$(usex !dbus)
		-DENABLE_GSTREAMER="$(usex gstreamer)"
		-DENABLE_LIBGPOD="$(usex ipod)"
		-DENABLE_LIBMTP="$(usex mtp)"
		-DENABLE_LIBPULSE="$(usex pulseaudio)"
		-DENABLE_UDISKS2="$(usex udisks)"
		-DENABLE_VLC="$(usex vlc)"
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
