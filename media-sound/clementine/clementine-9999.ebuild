# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://github.com/clementine-player/Clementine.git"

LANGS=" af ar be bg bn br bs ca cs cy da de el en_CA en_GB eo es et eu fa fi fr ga gl he he_IL hi hr hu hy ia id is it ja ka kk ko lt lv mr ms my nb nl oc pa pl pt pt_BR ro ru si_LK sk sl sr sr@latin sv te tr tr_TR uk uz vi zh_CN zh_TW"

inherit cmake-utils flag-o-matic fdo-mime gnome2-utils virtualx
[[ ${PV} == *9999* ]] && inherit git-r3

DESCRIPTION="A modern music player and library organizer based on Amarok 1.4 and Qt4"
HOMEPAGE="http://www.clementine-player.org https://github.com/clementine-player/Clementine"
[[ ${PV} == *9999* ]] || \
SRC_URI="https://github.com/clementine-player/Clementine/archive/${PV/_}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
[[ ${PV} == *9999* ]] || \
KEYWORDS="~amd64 ~x86"
IUSE="box cdda +dbus debug dropbox googledrive ipod lastfm mms moodbar mtp projectm pulseaudio seafile skydrive test +udisks udisks_legacy wiimote"
IUSE+="${LANGS// / linguas_}"

REQUIRED_USE="
	udisks? ( dbus )
	udisks_legacy? ( dbus )
	wiimote? ( dbus )
"

COMMON_DEPEND="
	dev-db/sqlite:=
	>=dev-libs/glib-2.24.1-r1
	dev-libs/libxml2
	dev-libs/protobuf:=
	dev-libs/qjson
	>=dev-qt/qtcore-4.5:4[ssl]
	>=dev-qt/qtgui-4.5:4
	>=dev-qt/qtopengl-4.5:4
	>=dev-qt/qtsql-4.5:4
	>=media-libs/chromaprint-0.6
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	>=media-libs/libmygpo-qt-1.0.9[qt4(+)]
	>=media-libs/taglib-1.8[mp4(+)]
	sys-libs/zlib
	dev-libs/crypto++
	virtual/glu
	virtual/opengl
	x11-libs/libX11
	cdda? ( dev-libs/libcdio )
	dbus? ( >=dev-qt/qtdbus-4.5:4 )
	ipod? ( >=media-libs/libgpod-0.8.0 )
	lastfm? ( >=media-libs/liblastfm-1[qt4(+)] )
	mtp? ( >=media-libs/libmtp-1.0.0 )
	moodbar? ( sci-libs/fftw:3.0 )
	projectm? ( media-libs/glew:=
			>=media-libs/libprojectm-1.2.0 )
"
# Note: sqlite driver of dev-qt/qtsql is bundled, so no sqlite use is required; check if this can be overcome someway;
# Libprojectm-1.2 seams to work fine, so no reasons to use bundled version; check the clementine's patches:
# https://github.com/clementine-player/Clementine/tree/master/3rdparty/libprojectm/patches
# Still possibly essential but not applied yet patches are:
# 06-fix-numeric-locale.patch
# 08-stdlib.h-for-rand.patch
RDEPEND="${COMMON_DEPEND}
	dbus? ( udisks? ( sys-fs/udisks:2 )
	        udisks_legacy? ( sys-fs/udisks:0 ) )
	mms? ( media-plugins/gst-plugins-libmms:1.0 )
	mtp? ( gnome-base/gvfs[mtp] )
	media-plugins/gst-plugins-meta:1.0
	media-plugins/gst-plugins-soup:1.0
	media-plugins/gst-plugins-taglib:1.0
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.39:=
	virtual/pkgconfig
	sys-devel/gettext
	dev-qt/qttest:4
	dev-cpp/gmock
	box? ( dev-cpp/sparsehash )
	dropbox? ( dev-cpp/sparsehash )
	googledrive? ( dev-cpp/sparsehash )
	seafile? ( dev-cpp/sparsehash )
	pulseaudio? ( media-sound/pulseaudio )
	skydrive? ( dev-cpp/sparsehash )
	test? ( gnome-base/gsettings-desktop-schemas )
"
DOCS=( Changelog README.md )

MY_P="${P/_}"
[[ ${PV} == *9999* ]] || \
S="${WORKDIR}/${MY_P^}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3-fix-tokenizer.patch
)

src_prepare() {
	cmake-utils_src_prepare

	# some tests fail or hang
	sed -i \
		-e '/add_test_file(translations_test.cpp/d' \
		tests/CMakeLists.txt || die
}

src_configure() {
	local langs x
	for x in ${LANGS}; do
		use linguas_${x} && langs+=" ${x}"
	done

	# spotify is not in portage
	local mycmakeargs=(
		-DBUILD_WERROR=OFF
		-DLINGUAS="${langs}"
		-DENABLE_AUDIOCD="$(usex cdda)"
		-DENABLE_DBUS="$(usex dbus)"
		-DENABLE_UDISKS2="$(usex udisks)"
		-DENABLE_DEVICEKIT="$(usex udisks_legacy)"
		-DENABLE_LIBGPOD="$(usex ipod)"
		-DENABLE_LIBLASTFM="$(usex lastfm)"
		-DENABLE_LIBMTP="$(usex mtp)"
		-DENABLE_MOODBAR="$(usex moodbar)"
		-DENABLE_GIO=ON
		-DENABLE_WIIMOTEDEV="$(usex wiimote)"
		-DENABLE_VISUALISATIONS="$(usex projectm)"
		-DENABLE_BOX="$(usex box)"
		-DENABLE_DROPBOX="$(usex dropbox)"
		-DENABLE_GOOGLE_DRIVE="$(usex googledrive)"
		-DENABLE_LIBPULSE="$(usex pulseaudio)"
		-DENABLE_SEAFILE="$(usex seafile)"
		-DENABLE_SKYDRIVE="$(usex skydrive)"
		-DENABLE_SPOTIFY_BLOB=OFF
		-DENABLE_BREAKPAD=OFF  #< disable crash reporting
		-DUSE_BUILTIN_TAGLIB=OFF
		-DUSE_SYSTEM_GMOCK=ON
		-DUSE_SYSTEM_PROJECTM=ON
		-DBUNDLE_PROJECTM_PRESETS=OFF
		# force to find crypto++ see bug #548544
		-DCRYPTOPP_LIBRARIES="crypto++"
		-DCRYPTOPP_FOUND=ON
		# avoid automagically enabling of ccache (bug #611010)
		-DCCACHE_EXECUTABLE=OFF
		)

	use !debug && append-cppflags -DQT_NO_DEBUG_OUTPUT

	cmake-utils_src_configure
}

src_test() {
	cd "${CMAKE_BUILD_DIR}" || die
	virtx emake test
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
