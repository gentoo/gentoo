# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional" # see src/apps/marble-kde/CMakeLists.txt
ECM_TEST="forceoptional"
KFMIN=5.88.0
QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Virtual Globe and World Atlas to learn more about Earth"
HOMEPAGE="https://marble.kde.org/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5/$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm64 ~riscv ~x86"
IUSE="aprs +dbus designer +geolocation gps +kde nls +pbf phonon shapefile +webengine"

# FIXME (new package): libwlocate, WLAN-based geolocation
BDEPEND="
	aprs? ( dev-lang/perl )
	nls? ( >=dev-qt/linguist-tools-${QTMIN}:5 )
"
DEPEND="
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	sys-libs/zlib
	aprs? ( >=dev-qt/qtserialport-${QTMIN}:5 )
	dbus? ( >=dev-qt/qtdbus-${QTMIN}:5 )
	designer? ( >=dev-qt/designer-${QTMIN}:5 )
	geolocation? ( >=dev-qt/qtpositioning-${QTMIN}:5 )
	gps? ( sci-geosciences/gpsd )
	kde? (
		>=kde-frameworks/kconfig-${KFMIN}:5
		>=kde-frameworks/kconfigwidgets-${KFMIN}:5
		>=kde-frameworks/kcoreaddons-${KFMIN}:5
		>=kde-frameworks/kcrash-${KFMIN}:5
		>=kde-frameworks/ki18n-${KFMIN}:5
		>=kde-frameworks/kio-${KFMIN}:5
		>=kde-frameworks/knewstuff-${KFMIN}:5
		>=kde-frameworks/kparts-${KFMIN}:5
		>=kde-frameworks/krunner-${KFMIN}:5
		>=kde-frameworks/kservice-${KFMIN}:5
		>=kde-frameworks/kwallet-${KFMIN}:5
	)
	pbf? ( dev-libs/protobuf:= )
	phonon? ( >=media-libs/phonon-4.11.0 )
	shapefile? ( sci-libs/shapelib:= )
	webengine? (
		>=dev-qt/qtwebchannel-${QTMIN}:5
		>=dev-qt/qtwebengine-${QTMIN}:5[widgets]
	)
"
RDEPEND="${DEPEND}"

# bug 588320
RESTRICT="test"

src_prepare() {
	ecm_src_prepare

	rm -rf src/3rdparty/zlib || die "Failed to remove bundled libs"

	use kde && cmake_run_in src/apps cmake_comment_add_subdirectory marble-qt
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package aprs Perl)
		$(cmake_use_find_package geolocation Qt5Positioning)
		-DBUILD_MARBLE_TESTS=$(usex test)
		-DWITH_DESIGNER_PLUGIN=$(usex designer)
		-DWITH_libgps=$(usex gps)
		-DWITH_KF5=$(usex kde)
		$(cmake_use_find_package pbf Protobuf)
		-DWITH_Phonon4Qt5=$(usex phonon)
		-DWITH_libshp=$(usex shapefile)
		$(cmake_use_find_package webengine Qt5WebEngine)
		$(cmake_use_find_package webengine Qt5WebEngineWidgets)
		-DWITH_libwlocate=OFF
		# bug 608890
		-DKDE_INSTALL_CONFDIR="/etc/xdg"
	)
	if use kde; then
		ecm_src_configure
	else
		cmake_src_configure
	fi
}
