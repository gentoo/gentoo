# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="KDE UML Modeller"
HOMEPAGE="
	https://www.kde.org/applications/development/umbrello
	https://umbrello.kde.org
"
KEYWORDS="amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep ktexteditor)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwebkit)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	dev-libs/libxml2
	dev-libs/libxslt
"
DEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kdelibs4support)
"
RDEPEND="${COMMON_DEPEND}
	!<kde-apps/kde4-l10n-17.07.80
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_KF5=ON
		-DBUILD_unittests=$(usex test)
	)
	use test && mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_LLVM=ON )

	kde5_src_configure
}
