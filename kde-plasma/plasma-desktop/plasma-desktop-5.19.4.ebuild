# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="true"
KFMIN=5.71.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.14.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="KDE Plasma desktop"
XORGHDRS="${PN}-override-include-dirs-0"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${XORGHDRS}.tar.xz"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="+fontconfig ibus scim +semantic-desktop"

COMMON_DEPEND="
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/attica-${KFMIN}:5
	>=kde-frameworks/kactivities-${KFMIN}:5
	>=kde-frameworks/kactivities-stats-${KFMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kauth-${KFMIN}:5
	>=kde-frameworks/kbookmarks-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/kded-${KFMIN}:5
	>=kde-frameworks/kdelibs4support-${KFMIN}:5
	>=kde-frameworks/kemoticons-${KFMIN}:5
	>=kde-frameworks/kglobalaccel-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/knotifyconfig-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/krunner-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/plasma-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	>=kde-frameworks/sonnet-${KFMIN}:5
	>=kde-plasma/kwin-${PVCUT}:5
	>=kde-plasma/libksysguard-${PVCUT}:5
	>=kde-plasma/plasma-workspace-${PVCUT}:5
	media-libs/phonon[qt5(+)]
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libxcb[xkb]
	x11-libs/libxkbfile
	fontconfig? (
		media-libs/fontconfig
		media-libs/freetype
		x11-libs/libXft
		x11-libs/xcb-util-image
	)
	ibus? (
		app-i18n/ibus
		dev-libs/glib:2
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libxcb
		x11-libs/xcb-util-keysyms
	)
	scim? ( app-i18n/scim )
	semantic-desktop? ( >=kde-frameworks/baloo-${KFMIN}:5 )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	x11-base/xorg-proto
	fontconfig? ( x11-libs/libXrender )
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/qqc2-desktop-style-${KFMIN}:5
	>=kde-plasma/breeze-${PVCUT}:5
	>=kde-plasma/kde-cli-tools-${PVCUT}:5
	>=kde-plasma/oxygen-${PVCUT}:5
	sys-apps/util-linux
	x11-apps/setxkbmap
	!<kde-plasma/kdeplasma-addons-5.15.80
"

PATCHES=(
	"${WORKDIR}/${XORGHDRS}/override-include-dirs.patch" # downstream patch
)

src_prepare() {
	ecm_src_prepare

	if ! use ibus; then
		sed -e "s/Qt5X11Extras_FOUND AND XCB_XCB_FOUND AND XCB_KEYSYMS_FOUND/false/" \
			-i applets/kimpanel/backend/ibus/CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package fontconfig Fontconfig)
		-DEvdev_INCLUDE_DIRS="${WORKDIR}/${XORGHDRS}"/include
		-DXORGLIBINPUT_INCLUDE_DIRS="${WORKDIR}/${XORGHDRS}"/include
		-DXORGSERVER_INCLUDE_DIRS="${WORKDIR}/${XORGHDRS}"/include
		-DSynaptics_INCLUDE_DIRS="${WORKDIR}/${XORGHDRS}"/include
		$(cmake_use_find_package scim SCIM)
		$(cmake_use_find_package semantic-desktop KF5Baloo)
	)
	if ! use ibus; then
		mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_IBus=ON )
	fi

	ecm_src_configure
}

src_test() {
	# parallel tests fail, foldermodeltest,positionertest hang, bug #646890
	# test_kio_fonts needs D-Bus, bug #634166
	# lookandfeel-kcmTest is unreliable for a long time, bug #607918
	local myctestargs=(
		-j1
		-E "(foldermodeltest|positionertest|test_kio_fonts|lookandfeel-kcmTest)"
	)

	ecm_src_test
}
