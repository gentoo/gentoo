# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional" # FIXME: Check back for doc in release
KDE_TEST="false"
KMNAME="akonadi-calendar-tools"
inherit kde5

DESCRIPTION="Tool to scan calendar data for buggy instances"
LICENSE="GPL-2+ handbook? ( FDL-1.2+ )"
KEYWORDS="amd64 ~arm64 x86"

IUSE=""

DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep ki18n)
	$(add_kdeapps_dep akonadi '' 18.12.3-r1)
	$(add_kdeapps_dep akonadi-calendar)
	$(add_kdeapps_dep calendarsupport)
	$(add_kdeapps_dep kcalcore)
	$(add_qt_dep qtwidgets)
"
RDEPEND="${DEPEND}
	!kde-apps/kdepim-l10n
"

src_prepare() {
	kde5_src_prepare

	cmake_comment_add_subdirectory doc konsolekalendar
	sed -i -e "/console\.categories/ s/^/#DONT/" CMakeLists.txt || die

	# delete colliding konsolekalendar translations
	if [[ ${KDE_BUILD_TYPE} = release ]]; then
		rm -f po/*/konsolekalendar.po || die
		rm -rf po/*/docs/konsolekalendar || die
	fi
}
