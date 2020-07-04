# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="LXQt desktop panel and plugins"
HOMEPAGE="https://lxqt.github.io/"

MY_PV="$(ver_cut 1-2)*"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://downloads.lxqt.org/downloads/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="+alsa colorpicker cpuload +desktopswitch +directorymenu dom +kbindicator +mainmenu
	+mount networkmonitor pulseaudio +quicklaunch sensors +showdesktop
	+spacer statusnotifier sysstat +taskbar +tray +volume +worldclock"

# Work around a missing header issue: https://bugs.gentoo.org/666278
REQUIRED_USE="
	|| ( desktopswitch mainmenu showdesktop taskbar )
	volume? ( || ( alsa pulseaudio ) )
"

BDEPEND="
	dev-qt/linguist-tools:5
	>=dev-util/lxqt-build-tools-0.6.0
	virtual/pkgconfig
"
DEPEND="
	>=dev-libs/libqtxdg-3.3.1
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	kde-frameworks/kwindowsystem:5[X]
	>=lxde-base/lxmenu-data-0.1.5
	>=lxde-base/menu-cache-1.1.0
	=lxqt-base/liblxqt-${MY_PV}
	=lxqt-base/lxqt-globalkeys-${MY_PV}
	x11-libs/libX11
	cpuload? ( sys-libs/libstatgrab )
	kbindicator? ( x11-libs/libxkbcommon )
	mount? ( kde-frameworks/solid:5 )
	networkmonitor? ( sys-libs/libstatgrab )
	sensors? ( sys-apps/lm-sensors )
	statusnotifier? ( dev-libs/libdbusmenu-qt[qt5(+)] )
	sysstat? ( >=lxqt-base/libsysstat-0.4.1 )
	tray? (
		x11-libs/libxcb:=
		x11-libs/libXcomposite
		x11-libs/libXdamage
		x11-libs/libXrender
		x11-libs/xcb-util
	)
	volume? (
		alsa? ( media-libs/alsa-lib )
		pulseaudio? (
			media-sound/pavucontrol-qt
			media-sound/pulseaudio
		)
	)
"
RDEPEND="${DEPEND}
	!lxqt-base/lxqt-l10n
"

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
		-DSENSORS_PLUGIN=$(usex sensors)
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
