# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_DESIGNERPLUGIN="true"
KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="A textedit with PIM-specific features"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
IUSE="speech"

COMMON_DEPEND="
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kemoticons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep sonnet)
	$(add_frameworks_dep syntax-highlighting)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	dev-libs/grantlee:5
	speech? ( $(add_qt_dep qtspeech) )
"
DEPEND="${COMMON_DEPEND}
	test? ( $(add_frameworks_dep ktextwidgets) )
"
RDEPEND="${COMMON_DEPEND}
	!kde-apps/kdepim-l10n
"

RESTRICT+=" test"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package speech Qt5TextToSpeech)
	)

	kde5_src_configure
}
