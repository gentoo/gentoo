# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="https://github.com/clementine-player/Clementine.git"

LANGS=" af ar be bg bn br bs ca cs cy da de el en_CA en_GB eo es et eu fa fi fr ga gl he he_IL hi hr hu hy ia id is it ja ka kk ko lt lv mr ms my nb nl oc pa pl pt pt_BR ro ru si_LK sk sl sr sr@latin sv te tr tr_TR uk uz vi zh_CN zh_TW"

inherit cmake-utils flag-o-matic fdo-mime gnome2-utils virtualx
[[ ${PV} == *9999* ]] && inherit git-2

DESCRIPTION="A modern music player and library organizer based on Amarok 1.4 and Qt4"
HOMEPAGE="http://www.clementine-player.org https://github.com/clementine-player/Clementine"
[[ ${PV} == *9999* ]] || \
SRC_URI="https://github.com/clementine-player/Clementine/archive/${PV/_}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
[[ ${PV} == *9999* ]] || \
KEYWORDS="~amd64 ~x86"
IUSE="box cdda +dbus debug dropbox googledrive ipod lastfm mms moodbar mtp projectm skydrive test ubuntu-one +udisks wiimote"
IUSE+="${LANGS// / linguas_}"

REQUIRED_USE="
	udisks? ( dbus )
	wiimote? ( dbus )
"

# qca dep is temporary for bug #489850
COMMON_DEPEND="
	dev-db/sqlite:=
	>=dev-libs/glib-2.24.1-r1
	dev-libs/libxml2
	dev-libs/protobuf:=
	dev-libs/qjson
	>=dev-qt/qtcore-4.5:4
	>=dev-qt/qtgui-4.5:4
	>=dev-qt/qtopengl-4.5:4
	>=dev-qt/qtsql-4.5:4[sqlite]
	>=media-libs/chromaprint-0.6
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	media-libs/libechonest:=[qt4]
	>=media-libs/libmygpo-qt-1.0.8
	>=media-libs/taglib-1.8[mp4]
	sys-libs/zlib
	virtual/glu
	virtual/opengl
	x11-libs/libX11
	cdda? ( dev-libs/libcdio )
	dbus? ( >=dev-qt/qtdbus-4.5:4 )
	ipod? ( >=media-libs/libgpod-0.8.0 )
	lastfm? ( >=media-libs/liblastfm-1[qt4(+)] )
	mtp? ( >=media-libs/libmtp-1.0.0 )
	moodbar? ( sci-libs/fftw:3.0 )
	projectm? ( media-libs/glew:= )
	>=dev-libs/crypto++-5.6.2-r4
"
# now only presets are used, libprojectm is internal
# https://github.com/clementine-player/Clementine/tree/master/3rdparty/libprojectm/patches
# r1966 "Compile with a static sqlite by default, since Qt 4.7 doesn't seem to expose the symbols we need to use FTS"
RDEPEND="${COMMON_DEPEND}
	dbus? ( udisks? ( sys-fs/udisks:2 ) )
	mms? ( media-plugins/gst-plugins-libmms:1.0 )
	mtp? ( gnome-base/gvfs )
	projectm? ( >=media-libs/libprojectm-1.2.0 )
	media-plugins/gst-plugins-meta:1.0
	media-plugins/gst-plugins-soup:1.0
	media-plugins/gst-plugins-taglib:1.0
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.39
	virtual/pkgconfig
	sys-devel/gettext
	dev-qt/qttest:4
	dev-cpp/gmock
	box? ( dev-cpp/sparsehash )
	dropbox? ( dev-cpp/sparsehash )
	googledrive? ( dev-cpp/sparsehash )
	skydrive? ( dev-cpp/sparsehash )
	ubuntu-one? ( dev-cpp/sparsehash )
	test? ( gnome-base/gsettings-desktop-schemas )
"
DOCS="Changelog"

# https://github.com/clementine-player/Clementine/issues/3935
RESTRICT="test"

MY_P="${P/_}"
# Switch to ^ when we switch to EAPI=6.
[[ ${PV} == *9999* ]] || \
S="${WORKDIR}/C${MY_P:1}"

PATCHES=( "${FILESDIR}"/${PN}-1.3-fix-tokenizer.patch )

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
		-DBUNDLE_PROJECTM_PRESETS=OFF
		-DUSE_SYSTEM_PROJECTM=ON
		$(cmake-utils_use cdda ENABLE_AUDIOCD)
		$(cmake-utils_use dbus ENABLE_DBUS)
		$(cmake-utils_use udisks ENABLE_DEVICEKIT)
		$(cmake-utils_use ipod ENABLE_LIBGPOD)
		$(cmake-utils_use lastfm ENABLE_LIBLASTFM)
		$(cmake-utils_use mtp ENABLE_LIBMTP)
		$(cmake-utils_use moodbar ENABLE_MOODBAR)
		-DENABLE_GIO=ON
		$(cmake-utils_use wiimote ENABLE_WIIMOTEDEV)
		$(cmake-utils_use projectm ENABLE_VISUALISATIONS)
		$(usex projectm '-DUSE_SYSTEM_PROJECTM=ON' '')
		$(cmake-utils_use box ENABLE_BOX)
		$(cmake-utils_use dropbox ENABLE_DROPBOX)
		$(cmake-utils_use googledrive ENABLE_GOOGLE_DRIVE)
		$(cmake-utils_use skydrive ENABLE_SKYDRIVE)
		$(cmake-utils_use ubuntu-one ENABLE_UBUNTU_ONE)
		-DENABLE_SPOTIFY_BLOB=OFF
		-DENABLE_BREAKPAD=OFF
		#$(cmake-utils_use !system-sqlite STATIC_SQLITE)
		#$(cmake-utils_use system-sqlite I_HATE_MY_USERS)
		#$(cmake-utils_use system-sqlite MY_USERS_WILL_SUFFER_BECAUSE_OF_ME)
		-DUSE_BUILTIN_TAGLIB=OFF
		-DUSE_SYSTEM_GMOCK=ON
		)

	use !debug && append-cppflags -DQT_NO_DEBUG_OUTPUT

	cmake-utils_src_configure
}

src_test() {
	cd "${CMAKE_BUILD_DIR}" || die
	Xemake test
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
