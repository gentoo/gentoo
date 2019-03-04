# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="5a8ebed6a30bba2e001fc5c5acc4f414d6405005"
KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Frontend to diff3 based on KDE Frameworks"
HOMEPAGE="https://userbase.kde.org/KDiff3"
SRC_URI="https://github.com/KDE/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}
	sys-apps/diffutils
	!kde-misc/kdiff3:4
"

PATCHES=( "${FILESDIR}/${P}-clangtidy-optional.patch" )

S="${WORKDIR}/${PN}-${COMMIT}"
