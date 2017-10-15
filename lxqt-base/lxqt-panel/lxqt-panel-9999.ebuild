# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="LXQt desktop panel and plugins"
HOMEPAGE="http://lxqt.org/"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxde/${PN}.git"
else
	SRC_URI="https://github.com/lxde/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="+alsa +clock colorpicker cpuload +desktopswitch dom +kbindicator +mainmenu
	+mount networkmonitor pulseaudio +quicklaunch sensors +showdesktop
	statusnotifier sysstat +taskbar +tray +volume worldclock"
REQUIRED_USE="volume? ( || ( alsa pulseaudio ) )"

CDEPEND="
	dev-libs/glib:2
	>=dev-libs/libqtxdg-2.0.0
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	kde-frameworks/kguiaddons:5
	kde-frameworks/kwindowsystem:5[X]
	>=lxde-base/menu-cache-0.3.3
	lxqt-base/liblxqt
	lxqt-base/lxqt-globalkeys
	x11-libs/libX11
	cpuload? ( sys-libs/libstatgrab )
	kbindicator? ( x11-libs/libxkbcommon )
	mount? ( kde-frameworks/solid:5 )
	networkmonitor? ( sys-libs/libstatgrab )
	sensors? ( sys-apps/lm_sensors )
	statusnotifier? ( dev-libs/libdbusmenu-qt[qt5] )
	sysstat? ( =lxqt-base/libsysstat-0.3* )
	tray? ( x11-libs/libXcomposite
		x11-libs/libXdamage
		x11-libs/libXrender )
	volume? ( alsa? ( media-libs/alsa-lib )
		pulseaudio? ( media-sound/pulseaudio ) )
"
DEPEND="${CDEPEND}
	dev-qt/linguist-tools:5
	>=dev-util/lxqt-build-tools-0.3.1
"
RDEPEND="${CDEPEND}
	dev-qt/qtsvg:5
	>=lxde-base/lxmenu-data-0.1.2
"

src_configure() {
	local mycmakeargs=(
		-DPULL_TRANSLATIONS=OFF
		$(usex clock '-DCLOCK_PLUGIN=ON' '-DCLOCK_PLUGIN=OFF')
		$(usex colorpicker '-DCOLORPICKER_PLUGIN=ON' '-DCOLORPICKER_PLUGIN=OFF')
		$(usex cpuload '-DCPULOAD_PLUGIN=ON' '-DCPULOAD_PLUGIN=OFF')
		$(usex desktopswitch '-DDESKTOPSWITCH_PLUGIN=ON' '-DDESKTOPSWITCH_PLUGIN=OFF')
		$(usex dom '-DDOM_PLUGIN=ON' '-DDOM_PLUGIN=OFF')
		$(usex kbindicator '-DKBINDICATOR_PLUGIN=ON' '-DKBINDICATOR_PLUGIN=OFF')
		$(usex mainmenu '-DMAINMENU_PLUGIN=ON' '-DMAINMENU_PLUGIN=OFF')
		$(usex mount '-DMOUNT_PLUGIN=ON' '-DMOUNT_PLUGIN=OFF')
		$(usex networkmonitor '-DNETWORKMONITOR_PLUGIN=ON' '-DNETWORKMONITOR_PLUGIN=OFF')
		$(usex quicklaunch '-DQUICKLAUNCH_PLUGIN=ON' '-DQUICKLAUNCH_PLUGIN=OFF')
		$(usex sensors '-DSENSORS_PLUGIN=ON' '-DSENSORS_PLUGIN=OFF')
		$(usex showdesktop '-DSHOWDESKTOP_PLUGIN=ON' '-DSHOWDESKTOP_PLUGIN=OFF')
		$(usex statusnotifier '-DSTATUSNOTIFIER_PLUGIN=ON' '-DSTATUSNOTIFIER_PLUGIN=OFF')
		$(usex sysstat '-DSYSSTAT_PLUGIN=ON' '-DSYSSTAT_PLUGIN=OFF')
		$(usex taskbar '-DTASKBAR_PLUGIN=ON' '-DTASKBAR_PLUGIN=OFF')
		$(usex tray '-DTRAY_PLUGIN=ON' '-DTRAY_PLUGIN=OFF')
		$(usex volume '-DVOLUME_PLUGIN=ON' '-DVOLUME_PLUGIN=OFF')
		$(usex worldclock '-DWORLDCLOCK_PLUGIN=ON' '-DWORLDCLOCK_PLUGIN=OFF')
	)

	if use volume; then
		mycmakeargs+=(
			$(usex alsa '-DVOLUME_USE_ALSA=ON' '-DVOLUME_USE_ALSA=OFF')
			$(usex pulseaudio '-DVOLUME_USE_PULSEAUDIO=ON' '-DVOLUME_USE_PULSEAUDIO=OFF')
		)
	fi

	cmake-utils_src_configure
}

src_install(){
	cmake-utils_src_install
	doman panel/man/*.1
}
