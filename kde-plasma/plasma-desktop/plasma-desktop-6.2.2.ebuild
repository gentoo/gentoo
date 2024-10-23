# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="true"
KFMIN=6.6.0
PVCUT=$(ver_cut 1-3)
QTMIN=6.7.2
inherit ecm plasma.kde.org optfeature

DESCRIPTION="KDE Plasma desktop"
XORGHDRS="${PN}-override-include-dirs-4"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${XORGHDRS}.tar.xz"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="ibus scim screencast sdl +semantic-desktop webengine"

RESTRICT="test" # missing selenium-webdriver-at-spi

# slot op: Uses Qt6::GuiPrivate for qtx11extras_p.h
# kde-frameworks/kwindowsystem[X]: Uses KX11Extras
COMMON_DEPEND="
	dev-libs/icu:=
	dev-libs/wayland
	>=dev-qt/qt5compat-${QTMIN}:6[qml]
	>=dev-qt/qtbase-${QTMIN}:6=[concurrent,dbus,gui,network,sql,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=dev-qt/qtwayland-${QTMIN}:6
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
	>=kde-plasma/kwin-${PVCUT}:6
	>=kde-plasma/libksysguard-${PVCUT}:6
	>=kde-plasma/libplasma-${PVCUT}:6
	>=kde-plasma/plasma-activities-${PVCUT}:6
	>=kde-plasma/plasma-activities-stats-${PVCUT}:6
	>=kde-plasma/plasma-workspace-${PVCUT}:6[screencast?]
	>=kde-plasma/plasma5support-${PVCUT}:6
	media-libs/libcanberra
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
	scim? ( app-i18n/scim )
	sdl? ( media-libs/libsdl2[joystick] )
	semantic-desktop? ( >=kde-frameworks/baloo-${KFMIN}:6 )
	webengine? (
		kde-apps/kaccounts-integration:6
		>=net-libs/accounts-qt-1.17[qt6(+)]
	)
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/wayland-protocols-1.25
	dev-libs/boost
	x11-base/xorg-proto
	test? (
		>=kde-frameworks/qqc2-desktop-style-${KFMIN}:6
		>=kde-plasma/kactivitymanagerd-${PVCUT}:6
	)
"
RDEPEND="${COMMON_DEPEND}
	!<kde-plasma/kdeplasma-addons-5.25.50
	!<kde-plasma/plasma-workspace-6.0.80
	dev-libs/kirigami-addons:6
	>=dev-qt/qtwayland-${QTMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/qqc2-desktop-style-${KFMIN}:6
	>=kde-plasma/oxygen-${PVCUT}:6
	kde-plasma/plasma-mimeapps-list
	media-fonts/noto-emoji
	sys-apps/util-linux
	x11-apps/setxkbmap
	x11-misc/xdg-user-dirs
	screencast? ( >=kde-plasma/kpipewire-${PVCUT}:6 )
	webengine? ( >=net-libs/signon-oauth2-0.25_p20210102[qt6(+)] )
"
BDEPEND="
	dev-util/intltool
	dev-util/wayland-scanner
	>=kde-frameworks/kcmutils-${KFMIN}:6
	virtual/pkgconfig
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

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "screen reader support" "app-accessibility/orca"
	fi
	ecm_pkg_postinst
}
