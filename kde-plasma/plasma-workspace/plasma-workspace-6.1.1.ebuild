# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="forceoptional"
KFMIN=6.3.0
PVCUT=$(ver_cut 1-3)
QTMIN=6.7.1
inherit ecm plasma.kde.org

DESCRIPTION="KDE Plasma workspace"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE="appstream +calendar +fontconfig geolocation gps +policykit
screencast +semantic-desktop systemd telemetry +wallpaper-metadata"

REQUIRED_USE="gps? ( geolocation )"
RESTRICT="test"

# kde-frameworks/kwindowsystem[X]: Uses KX11Extras
# slot op: Uses Qt::GuiPrivate for qtx11extras_p.h
# slot op: various private QtWaylandClient headers
COMMON_DEPEND="
	dev-libs/icu:=
	>=dev-libs/wayland-1.15
	>=dev-qt/qt5compat-${QTMIN}:6[qml]
	>=dev-qt/qtbase-${QTMIN}:6=[dbus,gui,libinput,network,sql,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6[widgets]
	>=dev-qt/qtshadertools-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=dev-qt/qtwayland-${QTMIN}:6=
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kauth-${KFMIN}:6
	>=kde-frameworks/kbookmarks-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kdeclarative-${KFMIN}:6
	>=kde-frameworks/kded-${KFMIN}:6
	>=kde-frameworks/kglobalaccel-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kidletime-${KFMIN}:6
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
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/ksvg-${KFMIN}:6
	>=kde-frameworks/ktexteditor-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kunitconversion-${KFMIN}:6
	>=kde-frameworks/kwallet-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6[X]
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/prison-${KFMIN}:6[qml]
	>=kde-frameworks/solid-${KFMIN}:6
	>=kde-plasma/breeze-${PVCUT}:6
	>=kde-plasma/kscreenlocker-${PVCUT}:6
	>=kde-plasma/kwayland-${PVCUT}:6
	>=kde-plasma/kwin-${PVCUT}:6
	>=kde-plasma/layer-shell-qt-${PVCUT}:6
	>=kde-plasma/libkscreen-${PVCUT}:6
	>=kde-plasma/libksysguard-${PVCUT}:6
	>=kde-plasma/libplasma-${PVCUT}:6
	>=kde-plasma/plasma-activities-${PVCUT}:6
	>=kde-plasma/plasma-activities-stats-${PVCUT}:6
	>=kde-plasma/plasma5support-${PVCUT}:6
	media-libs/libcanberra
	>=media-libs/phonon-4.12.0[qt6]
	sci-libs/libqalculate:=
	sys-libs/zlib
	virtual/libudev:=
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXcursor
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/xcb-util
	appstream? ( >=dev-libs/appstream-1[qt6] )
	calendar? ( >=kde-frameworks/kholidays-${KFMIN}:6 )
	fontconfig? (
		media-libs/fontconfig
		x11-libs/libXft
		x11-libs/xcb-util-image
	)
	geolocation? ( >=kde-frameworks/networkmanager-qt-${KFMIN}:6 )
	gps? ( sci-geosciences/gpsd )
	policykit? (
		>=sys-auth/polkit-qt-0.175[qt6]
		virtual/libcrypt:=
	)
	screencast? (
		>=dev-qt/qtbase-${QTMIN}:6=[opengl]
		>=kde-plasma/kpipewire-${PVCUT}:6
		media-libs/libglvnd
		>=media-video/pipewire-0.3:=
		x11-libs/libdrm
	)
	semantic-desktop? ( >=kde-frameworks/baloo-${KFMIN}:6 )
	systemd? ( sys-apps/systemd:= )
	telemetry? ( >=kde-frameworks/kuserfeedback-${KFMIN}:6 )
	wallpaper-metadata? ( kde-apps/libkexiv2:6 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/plasma-wayland-protocols-1.13.0
	dev-libs/qcoro[dbus]
	>=dev-qt/qtbase-${QTMIN}:6[concurrent]
	x11-base/xorg-proto
	fontconfig? ( x11-libs/libXrender )
"
RDEPEND="${COMMON_DEPEND}
	!kde-plasma/libkworkspace:5
	!<kde-plasma/plasma-desktop-5.27.0:5
	!kde-plasma/xembed-sni-proxy:*
	app-text/iso-codes
	dev-libs/kirigami-addons:6
	>=dev-qt/qttools-${QTMIN}:*[qdbus]
	kde-apps/kio-extras:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kquickcharts-${KFMIN}:6
	>=kde-plasma/kactivitymanagerd-${PVCUT}:6
	>=kde-plasma/milou-${PVCUT}:6
	>=kde-plasma/plasma-integration-${PVCUT}:6
	sys-apps/dbus
	x11-apps/xmessage
	x11-apps/xprop
	x11-apps/xrdb
	x11-apps/xsetroot
	policykit? ( sys-apps/accountsservice )
"
BDEPEND="
	>=dev-qt/qtwayland-${QTMIN}:6
	>=dev-util/wayland-scanner-1.19.0
	>=kde-frameworks/kcmutils-${KFMIN}:6
	virtual/pkgconfig
	test? ( >=dev-qt/qtwayland-${QTMIN}:6[compositor] )
"
PDEPEND=">=kde-plasma/kde-cli-tools-${PVCUT}:*"

PATCHES=(
	"${FILESDIR}/${PN}-5.22.5-krunner-cwd-at-home.patch" # TODO upstream: KDE-bug 432975, bug 767478
)

src_prepare() {
	ecm_src_prepare

	# TODO: try to get a build switch upstreamed
	if ! use screencast; then
		ecm_punt_bogus_dep KPipeWire
		sed -e "s/^pkg_check_modules.*PipeWire/#&/" -i CMakeLists.txt || die
	fi

	# TODO: try to get a build switch upstreamed
	if use geolocation; then
		use gps || sed -e "s/^pkg_check_modules.*LIBGPS/#&/" \
			-i dataengines/geolocation/CMakeLists.txt || die
	fi

	if ! use policykit; then
		cmake_run_in kcms cmake_comment_add_subdirectory users
	fi

	if ! use fontconfig; then
		ecm_punt_bogus_dep XCB IMAGE
		sed -e "s/check_X11_lib(Xft)/#&/" -i CMakeLists.txt || die
	fi

	# TODO: try to get a build switch upstreamed
	if ! use systemd; then
		sed -e "s/^pkg_check_modules.*SYSTEMD/#&/" -i CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DWITH_X11=ON # TODO: broken upstream, fix it if you can
		-DGLIBC_LOCALE_GEN=$(usex policykit)
		$(cmake_use_find_package appstream AppStreamQt)
		$(cmake_use_find_package calendar KF6Holidays)
		$(cmake_use_find_package fontconfig Fontconfig)
		$(cmake_use_find_package geolocation KF6NetworkManagerQt)
		$(cmake_use_find_package semantic-desktop KF6Baloo)
		$(cmake_use_find_package telemetry KF6UserFeedback)
		$(cmake_use_find_package wallpaper-metadata KExiv2Qt6)
	)

	ecm_src_configure
}

src_install() {
	ecm_src_install

	# default startup and shutdown scripts
	insinto /etc/xdg/plasma-workspace/env
	doins "${FILESDIR}"/10-agent-startup.sh

	insinto /etc/xdg/plasma-workspace/shutdown
	doins "${FILESDIR}"/10-agent-shutdown.sh
	fperms +x /etc/xdg/plasma-workspace/shutdown/10-agent-shutdown.sh
}

pkg_postinst () {
	ecm_pkg_postinst

	elog "To enable gpg-agent and/or ssh-agent in Plasma sessions,"
	elog "edit ${EPREFIX}/etc/xdg/plasma-workspace/env/10-agent-startup.sh"
	elog "and ${EPREFIX}/etc/xdg/plasma-workspace/shutdown/10-agent-shutdown.sh"
}
