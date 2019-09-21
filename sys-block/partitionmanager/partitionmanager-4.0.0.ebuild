# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FRAMEWORKS_MINIMAL="5.56"
KDE_HANDBOOK="optional"
inherit kde5

DESCRIPTION="Utility for management of disks, partitions and file systems"
HOMEPAGE="https://kde.org/applications/system/org.kde.partitionmanager"
[[ ${KDE_BUILD_TYPE} == release ]] && SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="GPL-3"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	>=sys-libs/kpmcore-4.0.0:5=
"
RDEPEND="${DEPEND}"
