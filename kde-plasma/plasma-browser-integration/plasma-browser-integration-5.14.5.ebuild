# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="Integrate Chrome/Firefox better into Plasma through browser extensions"

LICENSE="GPL-3+"
KEYWORDS="amd64 ~arm ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kactivities)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep krunner)
	$(add_frameworks_dep kwindowsystem)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DMOZILLA_DIR="${EPREFIX}/usr/$(get_libdir)/mozilla"
	)

	kde5_src_configure
}
