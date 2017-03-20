# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="KDE Plasma desktop"
KEYWORDS="amd64 ~arm ~x86"
IUSE="+fontconfig gtk2 gtk3 +input_devices_evdev input_devices_synaptics ibus
legacy-systray packagekit pulseaudio +qt4 scim +semantic-desktop"

COMMON_DEPEND="
	$(add_frameworks_dep attica)
	$(add_frameworks_dep kactivities)
	$(add_frameworks_dep kactivities-stats)
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
	$(add_frameworks_dep kitemmodels)
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
	$(add_plasma_dep kwin)
	$(add_plasma_dep plasma-workspace)
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
	$(add_qt_dep qtxml)
	media-libs/phonon[qt5]
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libxcb
	x11-libs/libxkbfile
	fontconfig? (
		media-libs/fontconfig
		media-libs/freetype
		x11-libs/libXft
		x11-libs/xcb-util-image
	)
	ibus? (
		$(add_qt_dep qtx11extras)
		app-i18n/ibus
		dev-libs/glib:2
		x11-libs/libxcb
		x11-libs/xcb-util-keysyms
	)
	input_devices_synaptics? ( x11-drivers/xf86-input-synaptics )
	packagekit? ( >=app-admin/packagekit-qt-0.9.6 )
	pulseaudio? (
		dev-libs/glib:2
		media-libs/libcanberra
		media-sound/pulseaudio
	)
	scim? ( app-i18n/scim )
	semantic-desktop? ( $(add_frameworks_dep baloo) )
"
RDEPEND="${COMMON_DEPEND}
	$(add_plasma_dep breeze)
	$(add_plasma_dep kde-cli-tools)
	$(add_plasma_dep oxygen)
	$(add_qt_dep qtgraphicaleffects)
	sys-apps/accountsservice
	x11-apps/setxkbmap
	legacy-systray? (
		gtk2? ( dev-libs/libappindicator:2 )
		gtk3? ( dev-libs/libappindicator:3 )
		qt4? ( dev-libs/sni-qt )
	)
	pulseaudio? ( $(add_plasma_dep plasma-pa ) )
	qt4? ( kde-plasma/qguiplatformplugin_kde:4 )
	!kde-apps/kcontrol
	!kde-apps/kdepasswd:4
	!kde-apps/knetattach[handbook]
	!kde-base/plasma-desktop:4
	!kde-plasma/plasma-workspace:4
	!kde-plasma/solid-actions-kcm:4
	!kde-plasma/systemsettings:4
	!kde-misc/kcm_touchpad
	!kde-misc/kcm-touchpad
	!kde-plasma/kcm-touchpad
	!<kde-plasma/kdeplasma-addons-5.5.50
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	x11-proto/xproto
	fontconfig? ( x11-libs/libXrender )
	input_devices_evdev? ( x11-drivers/xf86-input-evdev )
"

REQUIRED_USE="legacy-systray? ( || ( gtk2 gtk3 qt4 ) ) gtk2? ( legacy-systray ) gtk3? ( legacy-systray )"

PATCHES=( "${FILESDIR}/${P}-baloo-optional.patch" )

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
		$(cmake-utils_use_find_package ibus IBus)
		$(cmake-utils_use_find_package input_devices_evdev Evdev)
		$(cmake-utils_use_find_package input_devices_synaptics Synaptics)
		$(cmake-utils_use_find_package packagekit PackageKitQt5)
		$(cmake-utils_use_find_package pulseaudio PulseAudio)
		$(cmake-utils_use_find_package scim SCIM)
		$(cmake-utils_use_find_package semantic-desktop KF5Baloo)
	)

	kde5_src_configure
}
