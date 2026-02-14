# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="true"
KFMIN=6.18.0
QTMIN=6.10.1
inherit ecm plasma.kde.org optfeature xdg

DESCRIPTION="KDE Plasma desktop"
XORGHDRS="${PN}-override-include-dirs-4"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${XORGHDRS}.tar.xz"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="ibus input_devices_wacom scim screencast sdl +semantic-desktop webengine"

RESTRICT="test" # missing selenium-webdriver-at-spi

# slot op: Uses Qt6::GuiPrivate for qtx11extras_p.h
# kde-frameworks/kwindowsystem[X]: Uses KX11Extras
# kde-plasma/plasma-workspace[X]: applets/pager/pagermodel.cpp includes xwindowtasksmodel.h
COMMON_DEPEND="
	>=dev-qt/qt5compat-${QTMIN}:6[qml]
	>=dev-qt/qtbase-${QTMIN}:6=[concurrent,dbus,gui,network,sql,wayland,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtshadertools-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/attica-${KFMIN}:6
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kauth-${KFMIN}:6
	>=kde-frameworks/kbookmarks-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kded-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/knotifyconfig-${KFMIN}:6
	>=kde-frameworks/kpackage-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/krunner-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ksvg-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[X]
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	>=kde-frameworks/sonnet-${KFMIN}:6
	>=kde-plasma/kwin-${KDE_CATV}:6
	>=kde-plasma/libksysguard-${KDE_CATV}:6
	>=kde-plasma/libplasma-${KDE_CATV}:6
	>=kde-plasma/plasma-activities-${KDE_CATV}:6=
	>=kde-plasma/plasma-activities-stats-${KDE_CATV}:6
	>=kde-plasma/plasma-workspace-${KDE_CATV}:6[screencast?,X]
	>=kde-plasma/plasma5support-${KDE_CATV}:6
	media-libs/libcanberra
	virtual/libudev:=
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcursor
	x11-libs/libXi
	x11-libs/libxkbcommon
	x11-libs/libxkbfile
	ibus? (
		app-i18n/ibus
		dev-libs/glib:2
		x11-libs/xcb-util-keysyms
	)
	input_devices_wacom? (
		dev-libs/wayland
		dev-libs/libwacom:=
	)
	scim? ( app-i18n/scim )
	sdl? ( media-libs/libsdl2[joystick] )
	semantic-desktop? ( >=kde-frameworks/baloo-${KFMIN}:6 )
	webengine? (
		kde-apps/kaccounts-integration:6
		>=net-libs/accounts-qt-1.17[qt6(+)]
	)
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	x11-base/xorg-proto
	input_devices_wacom? ( >=dev-libs/wayland-protocols-1.44 )
	test? (
		>=kde-frameworks/qqc2-desktop-style-${KFMIN}:6
		>=kde-plasma/kactivitymanagerd-${KDE_CATV}:6
	)
"
RDEPEND="${COMMON_DEPEND}
	!<kde-plasma/plasma-workspace-6.0.80
	dev-libs/kirigami-addons:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-plasma/oxygen-${KDE_CATV}:6
	>=kde-plasma/plasma-mimeapps-list-3
	media-fonts/noto-emoji
	sys-apps/util-linux
	x11-apps/setxkbmap
	x11-misc/xdg-user-dirs
	screencast? ( >=kde-plasma/kpipewire-${KDE_CATV}:6 )
	webengine? ( >=net-libs/signon-oauth2-0.25_p20210102[qt6(+)] )
"
BDEPEND="
	dev-util/intltool
	>=kde-frameworks/kcmutils-${KFMIN}:6
	virtual/pkgconfig
	input_devices_wacom? ( dev-util/wayland-scanner )
"

PATCHES=(
	"${FILESDIR}/${PN}-6.1.80-override-include-dirs.patch" # downstream patch
)

src_prepare() {
	ecm_src_prepare

	if ! use ibus; then
		sed -e "s/XCB_XCB_FOUND AND XCB_KEYSYMS_FOUND/false/" \
			-i applets/kimpanel/backend/ibus/CMakeLists.txt || die
	fi

	# TODO: try to get a build switch upstreamed
	if ! use scim; then
		sed -e "s/^pkg_check_modules.*SCIM/#&/" -i CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_KCM_MOUSE_X11=ON
		-DBUILD_KCM_TOUCHPAD_X11=ON
		-DXORGLIBINPUT_INCLUDE_DIRS="${WORKDIR}/${XORGHDRS}"/include
		-DXORGSERVER_INCLUDE_DIRS="${WORKDIR}/${XORGHDRS}"/include
		-DCMAKE_DISABLE_FIND_PACKAGE_PackageKitQt6=ON # not packaged
		$(cmake_use_find_package ibus GLIB2)
		-DBUILD_KCM_TABLET=$(usex input_devices_wacom)
		$(cmake_use_find_package sdl SDL2)
		$(cmake_use_find_package semantic-desktop KF6Baloo)
		$(cmake_use_find_package webengine AccountsQt6)
		$(cmake_use_find_package webengine KAccounts6)
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

src_install() {
	cmake_src_install

	# Provide kde-mimeapps.list with distribution kde-plasma/plasma-mimeapps-list
	rm "${ED}"/usr/share/applications/kde-mimeapps.list || die
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "screen reader support" "app-accessibility/orca"
	fi
	xdg_pkg_postinst
}
