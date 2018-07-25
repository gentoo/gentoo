# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="Manage print jobs and printers in Plasma"
KEYWORDS="~amd64 ~x86"
IUSE="+gtk"

DEPEND="
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep plasma)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
	net-print/cups
"
RDEPEND="${DEPEND}
	$(add_plasma_dep kde-cli-tools)
	gtk? ( app-admin/system-config-printer )
"

pkg_postinst(){
	if ! use gtk ; then
		ewarn
		ewarn "By switching off \"gtk\" USE flag, you have chosen to do without"
		ewarn "an important, though optional, runtime dependency:"
		ewarn
		ewarn "app-admin/system-config-printer"
		ewarn
		ewarn "${PN} will work nevertheless, but is going to be less comfortable"
		ewarn "and will show the following error status during runtime:"
		ewarn
		ewarn "\"Failed to group devices: 'The name org.fedoraproject.Config.Printing"
		ewarn "was not provided by any .service files'\""
		ewarn
	fi
}
