# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils

DESCRIPTION="LXQt desktop panel and plugins"
HOMEPAGE="http://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"
else
	SRC_URI="https://downloads.lxqt.org/lxqt/${PV}/${P}.tar.xz"
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
	>=dev-libs/libqtxdg-1.0.0
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	kde-frameworks/kguiaddons:5
	kde-frameworks/kwindowsystem:5[X]
	>=lxde-base/menu-cache-0.3.3
	~lxqt-base/liblxqt-${PV}
	~lxqt-base/lxqt-globalkeys-${PV}
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
		pulseaudio? ( media-sound/pulseaudio ) )"
DEPEND="${CDEPEND}
	dev-qt/linguist-tools:5"
RDEPEND="${CDEPEND}
	dev-qt/qtsvg:5
	>=lxde-base/lxmenu-data-0.1.2"

src_configure() {
	local mycmakeargs i y
	mycmakeargs=( -DPULL_TRANSLATIONS=OFF )
	for i in clock colorpicker cpuload desktopswitch dom kbindicator mainmenu mount \
		networkmonitor quicklaunch sensors showdesktop statusnotifier \
		sysstat taskbar tray volume worldclock; do
		#Switch to ^^ when we switch to EAPI=6.
		#y=${i^^}
		y=$(tr '[:lower:]' '[:upper:]' <<< "${i}")
		mycmakeargs+=( $(cmake-utils_use ${i} ${y}_PLUGIN) )
	done

	if use volume; then
		mycmakeargs+=( $(cmake-utils_use alsa VOLUME_USE_ALSA)
			$(cmake-utils_use pulseaudio VOLUME_USE_PULSEAUDIO) )
	fi

	cmake-utils_src_configure
}

src_install(){
	cmake-utils_src_install
	doman panel/man/*.1
}
