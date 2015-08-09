# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="true"
KDE_TEST="true"
inherit kde5

DESCRIPTION="KDE Plasma desktop"
KEYWORDS="~amd64"
IUSE="+fontconfig gtk2 gtk3 legacy-systray pulseaudio +qt4 touchpad usb"

COMMON_DEPEND="
	$(add_plasma_dep baloo)
	$(add_plasma_dep kwin)
	$(add_plasma_dep plasma-workspace)
	$(add_frameworks_dep attica)
	$(add_frameworks_dep kactivities)
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kbookmarks)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep kded)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep kemoticons)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kpeople)
	$(add_frameworks_dep krunner)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep plasma)
	$(add_frameworks_dep solid)
	$(add_frameworks_dep sonnet)
	dev-qt/qtconcurrent:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	media-libs/phonon[qt5]
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcursor
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libxkbfile
	fontconfig? (
		media-libs/fontconfig
		media-libs/freetype
		x11-libs/libXft
		x11-libs/xcb-util-image
	)
	pulseaudio? (
		dev-libs/glib:2
		media-libs/libcanberra
		media-sound/pulseaudio
	)
	touchpad? ( x11-drivers/xf86-input-synaptics )
	usb? (
		x11-libs/libXcursor
		x11-libs/libXfixes
		virtual/libusb:0
	)
"
RDEPEND="${COMMON_DEPEND}
	$(add_plasma_dep breeze)
	$(add_plasma_dep kde-cli-tools)
	|| ( $(add_plasma_dep kio-extras) $(add_kdeapps_dep kio-extras ) )
	$(add_plasma_dep oxygen)
	sys-apps/accountsservice
	x11-apps/setxkbmap
	legacy-systray? (
		gtk2? ( dev-libs/libappindicator:2 )
		gtk3? ( dev-libs/libappindicator:3 )
		qt4? ( dev-libs/sni-qt )
	)
	qt4? ( kde-base/qguiplatformplugin_kde )
	!kde-apps/attica
	!kde-apps/kcontrol
	!kde-apps/kdepasswd
	!kde-apps/knetattach[handbook]
	!kde-base/plasma-desktop
	!kde-base/plasma-workspace
	!kde-base/solid-actions-kcm
	!kde-base/systemsettings
	!kde-misc/kcm_touchpad
	!kde-misc/kcm-touchpad
	!kde-plasma/kcm-touchpad
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	x11-proto/xproto
	fontconfig? ( x11-libs/libXrender )
"

REQUIRED_USE="legacy-systray? ( || ( gtk2 gtk3 qt4 ) ) gtk2? ( legacy-systray ) gtk3? ( legacy-systray )"

pkg_setup() {
	if has_version net-im/skype && use legacy-systray && use amd64; then
		einfo
		elog "You need to install dev-libs/sni-qt[abi_x86_32] as skype is a 32-bit binary."
		einfo
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package fontconfig Fontconfig)
		$(cmake-utils_use_find_package pulseaudio PulseAudio)
		$(cmake-utils_use_find_package usb USB)
		$(cmake-utils_use_find_package touchpad Synaptics)
	)

	kde5_src_configure
}
