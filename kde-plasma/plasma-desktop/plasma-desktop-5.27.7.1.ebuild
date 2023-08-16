# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="true"
KFMIN=5.106.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.15.9
inherit ecm plasma.kde.org optfeature

DESCRIPTION="KDE Plasma desktop"
XORGHDRS="${PN}-override-include-dirs-2"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${XORGHDRS}.tar.xz"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv x86"
IUSE="ibus +kaccounts scim screencast +semantic-desktop"

# kde-frameworks/kwindowsystem[X]: Uses KX11Extras
COMMON_DEPEND="
	dev-libs/wayland
	>=dev-qt/qtconcurrent-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwayland-${QTMIN}:5
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
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/kded-${KFMIN}:5
	>=kde-frameworks/kdelibs4support-${KFMIN}:5
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
	>=kde-frameworks/kpackage-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/krunner-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5[X]
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/plasma-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	>=kde-frameworks/sonnet-${KFMIN}:5
	>=kde-plasma/kwin-${PVCUT}:5
	>=kde-plasma/libksysguard-${PVCUT}:5
	>=kde-plasma/libkworkspace-${PVCUT}:5
	>=kde-plasma/plasma-workspace-${PVCUT}:5[screencast?]
	>=media-libs/phonon-4.11.0
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libxkbfile
	ibus? (
		app-i18n/ibus
		dev-libs/glib:2
		>=dev-qt/qtx11extras-${QTMIN}:5
		x11-libs/libxcb
		x11-libs/xcb-util-keysyms
	)
	kaccounts? (
		kde-apps/kaccounts-integration:5
		net-libs/accounts-qt
	)
	scim? ( app-i18n/scim )
	semantic-desktop? ( >=kde-frameworks/baloo-${KFMIN}:5 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/wayland-protocols-1.25
	dev-libs/boost
	x11-base/xorg-proto
"
RDEPEND="${COMMON_DEPEND}
	!<kde-plasma/kdeplasma-addons-5.25.50
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qtwaylandscanner-${QTMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/qqc2-desktop-style-${KFMIN}:5
	>=kde-plasma/kde-cli-tools-${PVCUT}:5
	>=kde-plasma/oxygen-${PVCUT}:5
	media-fonts/noto-emoji
	sys-apps/util-linux
	x11-apps/setxkbmap
	x11-misc/xdg-user-dirs
	kaccounts? ( net-libs/signon-oauth2 )
	screencast? ( >=kde-plasma/kpipewire-${PVCUT}:5 )
"
BDEPEND="
	>=kde-frameworks/kcmutils-${KFMIN}:5
	virtual/pkgconfig
"

PATCHES=(
	"${WORKDIR}/${XORGHDRS}/${PN}-5.25.80-override-include-dirs.patch" # downstream patch
)

src_prepare() {
	ecm_src_prepare

	if ! use ibus; then
		sed -e "s/Qt5X11Extras_FOUND AND XCB_XCB_FOUND AND XCB_KEYSYMS_FOUND/false/" \
			-i applets/kimpanel/backend/ibus/CMakeLists.txt || die
	fi

	# TODO: try to get a build switch upstreamed
	if ! use scim; then
		sed -e "s/^pkg_check_modules.*SCIM/#&/" -i CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_PackageKitQt5=ON # not packaged
		-DEVDEV_INCLUDE_DIRS="${WORKDIR}/${XORGHDRS}"/include
		-DXORGLIBINPUT_INCLUDE_DIRS="${WORKDIR}/${XORGHDRS}"/include
		-DXORGSERVER_INCLUDE_DIRS="${WORKDIR}/${XORGHDRS}"/include
		-DSYNAPTICS_INCLUDE_DIRS="${WORKDIR}/${XORGHDRS}"/include
		$(cmake_use_find_package ibus GLIB2)
		$(cmake_use_find_package kaccounts AccountsQt5)
		$(cmake_use_find_package kaccounts KAccounts)
		$(cmake_use_find_package semantic-desktop KF5Baloo)
	)

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

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "screen reader support" app-accessibility/orca
	fi
	ecm_pkg_postinst
}
