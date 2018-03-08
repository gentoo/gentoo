# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="KDE screen magnifier"
HOMEPAGE="https://www.kde.org/applications/utilities/kmag/"
KEYWORDS="~amd64 ~x86"
IUSE="keyboardfocus"

DEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtwidgets)
	keyboardfocus? ( media-libs/libqaccessibilityclient:5 )
"
RDEPEND="${DEPEND}
	!<kde-apps/kde4-l10n-17.07.80
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package keyboardfocus QAccessibilityClient)
	)

	kde5_src_configure
}
