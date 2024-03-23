# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="forceoptional"
KFMIN=5.106.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.15.9
inherit ecm plasma.kde.org

DESCRIPTION="KDE Plasma workspace"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="appstream +calendar +fontconfig geolocation gps +policykit
screencast +semantic-desktop telemetry +wallpaper-metadata"

REQUIRED_USE="gps? ( geolocation )"
RESTRICT="test"

# kde-frameworks/kwindowsystem[X]: Uses KX11Extras
# slot op: various private QtWaylandClient headers
COMMON_DEPEND="
	dev-libs/icu:=
	>=dev-libs/wayland-1.15
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5[widgets]
	>=dev-qt/qtgui-${QTMIN}:5=[jpeg,libinput]
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwayland-${QTMIN}:5=
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kauth-${KFMIN}:5
	>=kde-frameworks/kbookmarks-${KFMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/kded-${KFMIN}:5
	>=kde-frameworks/kglobalaccel-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kidletime-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/knotifyconfig-${KFMIN}:5
	>=kde-frameworks/kpackage-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kpeople-${KFMIN}:5
	>=kde-frameworks/krunner-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktexteditor-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kunitconversion-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5[X]
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/prison-${KFMIN}:5[qml]
	>=kde-frameworks/solid-${KFMIN}:5
	>=kde-plasma/breeze-${PVCUT}:5
	>=kde-plasma/kscreenlocker-${PVCUT}:5
	>=kde-plasma/kwayland-${KFMIN}:5
	>=kde-plasma/kwin-${PVCUT}:5
	>=kde-plasma/layer-shell-qt-${PVCUT}:5
	>=kde-plasma/libkscreen-${PVCUT}:5
	>=kde-plasma/libksysguard-${PVCUT}:5
	>=kde-plasma/libkworkspace-${PVCUT}:5
	>=kde-plasma/libplasma-${KFMIN}:5
	>=kde-plasma/plasma-activities-${KFMIN}:5
	>=kde-plasma/plasma-activities-stats-${KFMIN}:5
	>=media-libs/phonon-4.11.0[qt5(+)]
	sci-libs/libqalculate:=
	sys-libs/zlib
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
	appstream? ( <dev-libs/appstream-1[qt5] )
	calendar? ( >=kde-frameworks/kholidays-${KFMIN}:5 )
	fontconfig? (
		>=dev-qt/qtprintsupport-${QTMIN}:5
		media-libs/fontconfig
		x11-libs/libXft
		x11-libs/xcb-util-image
	)
	geolocation? ( >=kde-frameworks/networkmanager-qt-${KFMIN}:5 )
	gps? ( sci-geosciences/gpsd )
	policykit? (
		sys-auth/polkit-qt[qt5(+)]
		virtual/libcrypt:=
	)
	screencast? (
		>=dev-qt/qtgui-${QTMIN}:5=[egl]
		>=kde-plasma/kpipewire-${PVCUT}:5
		media-libs/libglvnd
		>=media-video/pipewire-0.3:=
		x11-libs/libdrm
	)
	semantic-desktop? ( >=kde-frameworks/baloo-${KFMIN}:5 )
	telemetry? ( kde-frameworks/kuserfeedback:5 )
	wallpaper-metadata? ( kde-apps/libkexiv2:5 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/plasma-wayland-protocols-1.6.0
	>=dev-libs/wayland-protocols-1.31
	>=dev-qt/qtconcurrent-${QTMIN}:5
	x11-base/xorg-proto
	fontconfig? ( x11-libs/libXrender )
"
RDEPEND="${COMMON_DEPEND}
	!<kde-plasma/breeze-5.22.90:5
	!<kde-plasma/plasma-desktop-5.27.0:5
	app-text/iso-codes
	>=dev-qt/qdbus-${QTMIN}:*
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
	>=dev-qt/qtquickcontrols-${QTMIN}:5[widgets]
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	|| (
		kde-apps/kio-extras-kf5:5
		kde-apps/kio-extras:5
	)
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/kquickcharts-${KFMIN}:5
	>=kde-plasma/kactivitymanagerd-${PVCUT}:5
	>=kde-plasma/milou-${PVCUT}:5
	>=kde-plasma/plasma-integration-${PVCUT}:5
	sys-apps/dbus
	x11-apps/xmessage
	x11-apps/xprop
	x11-apps/xrdb
	x11-apps/xsetroot
	policykit? ( sys-apps/accountsservice )
"
BDEPEND="
	>=dev-qt/qtwaylandscanner-${QTMIN}:5
	>=dev-util/wayland-scanner-1.19.0
	>=kde-frameworks/kcmutils-${KFMIN}:5
	virtual/pkgconfig
"
PDEPEND=">=kde-plasma/kde-cli-tools-${PVCUT}:*"

PATCHES=(
	"${FILESDIR}/${PN}-5.24.80-split-libkworkspace.patch" # downstream
	"${FILESDIR}/${PN}-5.22.5-krunner-cwd-at-home.patch" # TODO upstream: KDE-bug 432975, bug 767478
)

src_prepare() {
	ecm_src_prepare

	cmake_comment_add_subdirectory libkworkspace
	# delete colliding libkworkspace translations
	find po -type f -name "*po" -and -name "libkworkspace*" -delete || die

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
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_xembed-sni-proxy=OFF
		-DGLIBC_LOCALE_GEN=$(usex policykit)
		$(cmake_use_find_package appstream AppStreamQt)
		$(cmake_use_find_package calendar KF5Holidays)
		$(cmake_use_find_package fontconfig Fontconfig)
		$(cmake_use_find_package geolocation KF5NetworkManagerQt)
		$(cmake_use_find_package semantic-desktop KF5Baloo)
		$(cmake_use_find_package telemetry KUserFeedback)
		$(cmake_use_find_package wallpaper-metadata KF5KExiv2)
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
