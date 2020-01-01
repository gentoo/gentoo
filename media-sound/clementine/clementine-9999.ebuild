# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="af ar be bg bn br bs ca cs cy da de el en en_CA en_GB eo es et eu fa fi fr ga gl he he_IL hi hr hu hy ia id is it ja ka kk ko lt lv mk_MK mr ms my nb nl oc pa pl pt pt_BR ro ru si_LK sk sl sr sr@latin sv te tr tr_TR uk uz vi zh_CN zh_TW"

inherit cmake flag-o-matic l10n virtualx xdg

MY_P="${P/_}"
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/clementine-player/Clementine.git"
	inherit git-r3
else
	S="${WORKDIR}/${PN^}-${PV}"
	SRC_URI_BASE="https://github.com/clementine-player/${PN^}"
	COMMIT=""
	if [[ -n "${COMMIT}" ]] ; then
		SRC_URI="${SRC_URI_BASE}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}/${PN^}-${COMMIT}"
	elif [[ $(ver_cut 3) -gt 90 ]] ; then
		SRC_URI="${SRC_URI_BASE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	else
		SRC_URI="${SRC_URI_BASE}/releases/download/${PV}/${P}.tar.xz"
	fi
	KEYWORDS="~amd64 ~x86"
fi
DESCRIPTION="Modern music player and library organizer based on Amarok 1.4 and Qt"
HOMEPAGE="https://www.clementine-player.org https://github.com/clementine-player/Clementine"

LICENSE="GPL-3"
SLOT="0"
IUSE="box cdda +dbus debug dropbox googledrive ipod lastfm mms moodbar mtp projectm pulseaudio seafile skydrive test +udisks wiimote"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	udisks? ( dbus )
	wiimote? ( dbus )
"

BDEPEND="
	>=dev-cpp/gtest-1.8.0
	dev-qt/linguist-tools:5
	sys-devel/gettext
	virtual/pkgconfig
	test? (
		dev-qt/qttest:5
		gnome-base/gsettings-desktop-schemas
	)
"
COMMON_DEPEND="
	app-crypt/qca:2[qt5(+)]
	dev-db/sqlite:=
	dev-libs/crypto++:=
	dev-libs/glib:2
	dev-libs/libxml2
	dev-libs/protobuf:=
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtwidgets:5
	media-libs/chromaprint:=
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	>=media-libs/libmygpo-qt-1.0.9[qt5(+)]
	>=media-libs/taglib-1.11.1_p20181028
	sys-libs/zlib
	virtual/glu
	x11-libs/libX11
	cdda? ( dev-libs/libcdio:= )
	dbus? ( dev-qt/qtdbus:5 )
	ipod? ( >=media-libs/libgpod-0.8.0 )
	lastfm? ( >=media-libs/liblastfm-1.1.0_pre20150206 )
	moodbar? ( sci-libs/fftw:3.0 )
	mtp? ( >=media-libs/libmtp-1.0.0 )
	projectm? (
		media-libs/glew:=
		>=media-libs/libprojectm-1.2.0:=
		virtual/opengl
	)
"
RDEPEND="${COMMON_DEPEND}
	media-plugins/gst-plugins-meta:1.0
	media-plugins/gst-plugins-soup:1.0
	media-plugins/gst-plugins-taglib:1.0
	mms? ( media-plugins/gst-plugins-libmms:1.0 )
	mtp? ( gnome-base/gvfs[mtp] )
	udisks? ( sys-fs/udisks:2 )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	dev-qt/qtopengl:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	box? ( dev-cpp/sparsehash )
	dropbox? ( dev-cpp/sparsehash )
	googledrive? ( dev-cpp/sparsehash )
	pulseaudio? ( media-sound/pulseaudio )
	seafile? ( dev-cpp/sparsehash )
	skydrive? ( dev-cpp/sparsehash )
"

DOCS=( Changelog README.md )

src_prepare() {
	l10n_find_plocales_changes "src/translations" "" ".po"

	cmake_src_prepare
	# some tests fail or hang
	sed -i \
		-e '/add_test_file(translations_test.cpp/d' \
		tests/CMakeLists.txt || die

	if ! use test; then
		sed -e "/find_package.*Qt5/s:\ Test::" -i CMakeLists.txt || die
		cmake_comment_add_subdirectory tests
	fi

	rm -r 3rdparty/{libmygpo-qt,libmygpo-qt5,taglib} || die
}

src_configure() {
	# spotify is not in portage
	local mycmakeargs=(
		-DBUILD_WERROR=OFF
		# force to find crypto++ see bug #548544
		-DCRYPTOPP_LIBRARIES="cryptopp"
		-DCRYPTOPP_FOUND=ON
		# avoid automagically enabling of ccache (bug #611010)
		-DCCACHE_EXECUTABLE=OFF
		-DENABLE_BREAKPAD=OFF  #< disable crash reporting
		-DENABLE_DEVICEKIT=OFF
		-DENABLE_GIO=ON
		-DENABLE_SPOTIFY_BLOB=OFF
		-DUSE_SYSTEM_GMOCK=ON
		-DUSE_SYSTEM_PROJECTM=ON
		-DBUNDLE_PROJECTM_PRESETS=OFF
		-DLINGUAS="$(l10n_get_locales)"
		-DENABLE_BOX="$(usex box)"
		-DENABLE_AUDIOCD="$(usex cdda)"
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5DBus=$(usex !dbus)
		-DENABLE_DROPBOX="$(usex dropbox)"
		-DENABLE_GOOGLE_DRIVE="$(usex googledrive)"
		-DENABLE_LIBGPOD="$(usex ipod)"
		-DENABLE_LIBLASTFM="$(usex lastfm)"
		-DENABLE_MOODBAR="$(usex moodbar)"
		-DENABLE_LIBMTP="$(usex mtp)"
		-DENABLE_VISUALISATIONS="$(usex projectm)"
		-DENABLE_SEAFILE="$(usex seafile)"
		-DENABLE_SKYDRIVE="$(usex skydrive)"
		-DENABLE_LIBPULSE="$(usex pulseaudio)"
		-DENABLE_UDISKS2="$(usex udisks)"
		-DENABLE_WIIMOTEDEV="$(usex wiimote)"
	)

	use !debug && append-cppflags -DQT_NO_DEBUG_OUTPUT

	cmake_src_configure
}

src_test() {
	cd "${CMAKE_BUILD_DIR}" || die
	virtx emake test
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "Note that list of supported formats is controlled by media-plugins/gst-plugins-meta "
	elog "USE flags. You may be interested in setting aac, flac, mp3, ogg or wavpack USE flags "
	elog "depending on your preferences"
}
