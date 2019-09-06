# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="VNC-compatible server to share Plasma desktops"
HOMEPAGE="https://kde.org/applications/system/krfb/"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="wayland"

DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdnssd)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
	>=net-libs/libvncserver-0.9.9
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXtst
	x11-libs/xcb-util-image
	wayland? ( media-video/pipewire:= )
"
RDEPEND="${DEPEND}
	wayland? ( sys-apps/xdg-desktop-portal[screencast] )
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package wayland PipeWire)
	)

	kde5_src_configure
}
