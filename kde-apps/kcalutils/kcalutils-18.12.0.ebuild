# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Library providing utility functions for the handling of calendar data"
LICENSE="GPL-2+ LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_kdeapps_dep kcalcore)
	$(add_kdeapps_dep kidentitymanagement)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	dev-libs/grantlee:5
"
RDEPEND="${DEPEND}
	!kde-apps/kdepim-l10n
"

src_test() {
	# bug 653616
	local myctestargs=(
		-E "(kcalutils-testincidenceformatter)"
	)

	kde5_src_test
}
