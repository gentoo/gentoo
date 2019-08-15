# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
inherit kde5

DESCRIPTION="MathML-based 2D and 3D graph calculator by KDE"
HOMEPAGE="https://kde.org/applications/education/kalgebra https://edu.kde.org/kalgebra/"
KEYWORDS="~amd64 ~arm64 ~x86"
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
	$(add_frameworks_dep kirigami)
	$(add_qt_dep qtquickcontrols)
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package readline Readline)
	)

	kde5_src_configure
}
