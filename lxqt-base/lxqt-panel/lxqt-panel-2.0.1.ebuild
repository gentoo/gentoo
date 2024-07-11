# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="LXQt desktop panel and plugins"
HOMEPAGE="https://lxqt-project.org/"

MY_PV="$(ver_cut 1-2)"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="LGPL-2.1 LGPL-2.1+"
SLOT="0"
IUSE="
	+alsa colorpicker cpuload +desktopswitch +directorymenu dom +kbindicator
	+mainmenu +mount networkmonitor pulseaudio +quicklaunch lm-sensors +showdesktop
	+spacer +statusnotifier sysstat +taskbar tray +volume +worldclock
"

# Work around a missing header issue: https://bugs.gentoo.org/666278
REQUIRED_USE="
	|| ( desktopswitch mainmenu showdesktop taskbar )
	volume? ( || ( alsa pulseaudio ) )
"

BDEPEND="
	>=dev-qt/qttools-6.6:6[linguist]
	>=dev-util/lxqt-build-tools-2.0.0
	virtual/pkgconfig
"
DEPEND="
	>=dev-libs/libqtxdg-4.0.0
	>=dev-qt/qtbase-6.6:6[dbus,gui,widgets,xml]
	>=dev-qt/qtsvg-6.6:6
	kde-frameworks/kwindowsystem:6[X]
	kde-plasma/layer-shell-qt:6
	>=lxde-base/menu-cache-1.1.0
	=lxqt-base/liblxqt-${MY_PV}*:=
	=lxqt-base/lxqt-globalkeys-${MY_PV}*
	=lxqt-base/lxqt-menu-data-${MY_PV}*
	x11-libs/libX11
	cpuload? ( sys-libs/libstatgrab )
	kbindicator? ( x11-libs/libxkbcommon )
	lm-sensors? ( sys-apps/lm-sensors:= )
	mount? ( kde-frameworks/solid:6 )
	networkmonitor? ( sys-libs/libstatgrab )
	statusnotifier? (
		dev-libs/libdbusmenu-lxqt
		>=dev-qt/qtbase-6.6:6[concurrent]
	)
	sysstat? ( >=lxqt-base/libsysstat-1.0.0 )
	tray? (
		x11-libs/libxcb:=
		x11-libs/libXcomposite
		x11-libs/libXdamage
		x11-libs/libXrender
		x11-libs/libXtst
		x11-libs/xcb-util
		x11-libs/xcb-util-image
	)
	volume? (
		alsa? ( media-libs/alsa-lib )
		pulseaudio? (
			media-libs/libpulse
			media-sound/pavucontrol-qt
		)
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		# Plugins
		-DCOLORPICKER_PLUGIN=$(usex colorpicker)
		-DCPULOAD_PLUGIN=$(usex cpuload)
		-DDESKTOPSWITCH_PLUGIN=$(usex desktopswitch)
		-DDIRECTORYMENU_PLUGIN=$(usex directorymenu)
		-DDOM_PLUGIN=$(usex dom)
		-DKBINDICATOR_PLUGIN=$(usex kbindicator)
		-DMAINMENU_PLUGIN=$(usex mainmenu)
		-DMOUNT_PLUGIN=$(usex mount)
		-DNETWORKMONITOR_PLUGIN=$(usex networkmonitor)
		-DQUICKLAUNCH_PLUGIN=$(usex quicklaunch)
		-DSENSORS_PLUGIN=$(usex lm-sensors)
		-DSHOWDESKTOP_PLUGIN=$(usex showdesktop)
		-DSPACER_PLUGIN=$(usex spacer)
		-DSTATUSNOTIFIER_PLUGIN=$(usex statusnotifier)
		-DSYSSTAT_PLUGIN=$(usex sysstat)
		-DTASKBAR_PLUGIN=$(usex taskbar)
		-DTRAY_PLUGIN=$(usex tray)
		-DVOLUME_PLUGIN=$(usex volume)
		-DWORLDCLOCK_PLUGIN=$(usex worldclock)
	)

	if use volume; then
		mycmakeargs+=(
			-DVOLUME_USE_ALSA=$(usex alsa)
			-DVOLUME_USE_PULSEAUDIO=$(usex pulseaudio)
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install
	doman panel/man/*.1
}
