# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="true"
KFMIN=5.115.0
QTMIN=5.15.12
inherit ecm kde.org optfeature

DESCRIPTION="Desktop Planetarium"
HOMEPAGE="https://apps.kde.org/kstars/ https://kstars.kde.org/"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-2+ GPL-3+"
SLOT="5"
IUSE="opencv +password raw"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="
	>=dev-qt/qtdatavis3d-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwebsockets-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/knotifyconfig-${KFMIN}:5
	>=kde-frameworks/kplotting-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	sci-astronomy/wcslib:=
	sci-libs/cfitsio:=
	sci-libs/gsl:=
	>=sci-libs/indilib-2.0.2
	sci-libs/libnova:=
	>=sci-libs/stellarsolver-2.2
	sys-libs/zlib
	opencv? (
		media-libs/opencv:=[ffmpeg]
		|| (
			media-libs/opencv[qt5(-)]
			media-libs/opencv[qt6(-)]
			media-libs/opencv[gtk3(-)]
		)
	)
	password? ( dev-libs/qtkeychain:=[qt5(+)] )
	raw? ( media-libs/libraw:= )
"
# TODO: Add back when re-enabled by upstream
# 	opengl? (
# 		>=dev-qt/qtopengl-${QTMIN}:5
# 		virtual/opengl
# 	)
DEPEND="${COMMON_DEPEND}
	dev-cpp/eigen:3
	>=dev-qt/qtconcurrent-${QTMIN}:5
	test? ( sci-astronomy/erfa )
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
	>=dev-qt/qtpositioning-${QTMIN}:5
	>=dev-qt/qtquickcontrols-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
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
	"${FILESDIR}/${P}-cmake.patch" # bug 895892
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_PYKSTARS=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_LibXISF=ON # not packaged
		-DBUILD_DOC=$(usex handbook)
		$(cmake_use_find_package opencv OpenCV)
		$(cmake_use_find_package password Qt5Keychain)
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
	ecm_pkg_postinst
}
