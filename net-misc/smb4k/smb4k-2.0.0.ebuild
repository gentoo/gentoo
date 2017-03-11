# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Advanced network neighborhood browser"
HOMEPAGE="https://sourceforge.net/p/smb4k/home/Home/"
[[ ${PV} != 9999 ]] && SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

[[ ${PV} != 9999 ]] && KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
IUSE=""

DEPEND="
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qttest)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}
	>=net-fs/samba-3.4.2[cups]
	!net-misc/smb4k:4
"

PATCHES=( "${FILESDIR}"/${PN}-1.9.90-po2.patch )
