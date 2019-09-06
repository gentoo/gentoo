# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="false"
inherit kde5

DESCRIPTION="Library for encryption handling"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+fancyviewer"

COMMON_DEPEND="
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	>=app-crypt/gpgme-1.11.1[cxx,qt5]
	fancyviewer? ( $(add_kdeapps_dep kpimtextedit) )
"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
"
RDEPEND="${COMMON_DEPEND}
	!kde-apps/kdepim-l10n
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package fancyviewer KF5PimTextEdit)
	)

	cmake-utils_src_configure
}
