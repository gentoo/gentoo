# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Common PIM libraries"
LICENSE="GPL-2+ LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
IUSE="ssl"

# drop qtwebengine subslot operator when QT_MINIMAL >= 5.8.0
DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep kwindowsystem)
	$(add_kdeapps_dep akonadi)
	$(add_kdeapps_dep kidentitymanagement)
	$(add_kdeapps_dep kmailtransport)
	$(add_kdeapps_dep kpimtextedit)
	$(add_kdeapps_dep libkdepim)
	$(add_kdeapps_dep pimcommon)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwebengine 'widgets' '' '5=')
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	ssl? ( dev-libs/cyrus-sasl )
"
RDEPEND="${DEPEND}
	!kde-apps/kdepim-kioslaves
"

RESTRICT+=" test"

src_prepare() {
	kde5_src_prepare

	if ! use_if_iuse handbook ; then
		sed -e "/add_subdirectory(doc)/I s/^/#DONOTCOMPILE /" \
			-i kioslave/CMakeLists.txt || die "failed to comment add_subdirectory(doc)"
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package ssl Sasl2)
	)
	kde5_src_configure
}
