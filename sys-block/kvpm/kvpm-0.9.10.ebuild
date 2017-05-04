# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_DOC_DIR="docbook"
KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="KDE frontend for Linux LVM2 and GNU parted"
HOMEPAGE="http://kvpm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="5"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	sys-apps/util-linux
	>=sys-block/parted-2.3
	>=sys-fs/lvm2-2.02.120
	!sys-block/kvpm:4
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-0.9.9-glibc-sysmacros.patch" )
