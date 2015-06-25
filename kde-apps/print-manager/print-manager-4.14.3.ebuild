# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-apps/print-manager/print-manager-4.14.3.ebuild,v 1.2 2015/06/25 15:59:38 johu Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="Manage print jobs and printers in KDE"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug +gtk"

DEPEND="
	>=net-print/cups-1.5.0[dbus]
"
RDEPEND="${DEPEND}
	!kde-base/printer-applet:4
	!kde-base/system-config-printer-kde:4
	!kde-misc/print-manager
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
