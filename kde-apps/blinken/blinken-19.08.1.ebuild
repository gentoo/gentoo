# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Memory enhancement game based on KDE Frameworks"
HOMEPAGE="https://kde.org/applications/education/blinken
https://edu.kde.org/blinken/"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	media-libs/phonon[qt5(+)]
"
RDEPEND="${DEPEND}"

src_install() {
	kde5_src_install
	rm "${ED}"/usr/share/${PN}/README.packagers || die
}
