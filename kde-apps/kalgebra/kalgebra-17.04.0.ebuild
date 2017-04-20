# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
inherit kde5

DESCRIPTION="MathML-based graph calculator by KDE"
HOMEPAGE="https://www.kde.org/applications/education/kalgebra
https://edu.kde.org/kalgebra"
KEYWORDS="~amd64 ~x86"
IUSE="readline"

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_kdeapps_dep analitza)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtwebengine 'widgets')
	$(add_qt_dep qtwidgets)
	readline? ( sys-libs/readline:0= )
"
RDEPEND="${DEPEND}
	$(add_qt_dep qtquickcontrols)
	dev-libs/kirigami:2
	!kde-apps/analitza:4
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package readline Readline)
	)

	kde5_src_configure
}
