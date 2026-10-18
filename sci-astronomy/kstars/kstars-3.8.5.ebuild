# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=6.29.0
QTMIN=6.11.2
inherit ecm kde.org optfeature xdg

DESCRIPTION="Desktop Planetarium"
HOMEPAGE="https://apps.kde.org/kstars/ https://kstars.kde.org/"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
IUSE="+password raw"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
# currently broken w/ KF6, https://invent.kde.org/education/kstars/-/issues/294
RESTRICT="test"

COMMON_DEPEND="
	dev-cpp/eigen:=
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,sql,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtgraphs-${QTMIN}:6[quick3d]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=dev-qt/qtwebsockets-${QTMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/knotifyconfig-${KFMIN}:6
	>=kde-frameworks/kplotting-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	media-libs/opencv:=[ffmpeg]
	sci-astronomy/wcslib:=
	sci-libs/cfitsio:=
	sci-libs/gsl:=
	>=sci-libs/indilib-2.0.2
	sci-libs/libnova:=
	>=sci-libs/stellarsolver-2.7
	virtual/zlib:=
	password? ( >=dev-libs/qtkeychain-0.16.0:= )
	raw? ( media-libs/libraw:= )
"
# TODO: what about virtual/opengl?
DEPEND="${COMMON_DEPEND}
	>=dev-qt/qtbase-${QTMIN}:6[concurrent]
	test? ( sci-astronomy/erfa )
"
RDEPEND="${COMMON_DEPEND}
	!${CATEGORY}/${PN}:5
	>=dev-qt/qt5compat-${QTMIN}:6[qml]
	>=dev-qt/qtpositioning-${QTMIN}:6
"

CMAKE_SKIP_TESTS=(
	# bug 842768, test declared unstable by upstream
	TestKSPaths
	# bugs 923871, 939788
	TestPlaceholderPath # ki18n (KLocalizedString) failure
	# all fail with offscreen plugin
	TestEkos{Capture,FilterWheel,Focus,Mount,Scheduler{,Ops},Simulator}
)

PATCHES=(
	# downstream patch
	"${FILESDIR}"/${PN}-3.8.1-cmake.patch # bug 895892
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_PYKSTARS=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_LibXISF=ON # not packaged
		-DBUILD_WITH_QT6=ON # KF6 please
		-DENABLE_SENTRY=OFF
		$(cmake_use_find_package password Qt6Keychain)
		$(cmake_use_find_package raw LibRaw)
	)

	ecm_src_configure
}

src_test() {
	LC_NUMERIC="C" LC_TIME="C" TZ=UTC ecm_src_test
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "Display 'current' pictures of planets" x11-misc/xplanet
	fi
	xdg_pkg_postinst
}
