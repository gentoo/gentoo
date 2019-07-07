# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
inherit kde5

DESCRIPTION="Remote desktop connection (RDP and VNC) client"
HOMEPAGE="https://kde.org/applications/internet/krdc/"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+rdp vnc"

#nx? ( >=net-misc/nxcl-0.9-r1 ) disabled upstream, last checked 2016-01-24
DEPEND="
	$(add_frameworks_dep kbookmarks)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdnssd)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	vnc? ( >=net-libs/libvncserver-0.9 )
"
RDEPEND="${DEPEND}
	rdp? ( >=net-misc/freerdp-1.1.0_beta1[X] )
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package vnc LibVNCServer)
	)

	kde5_src_configure
}
