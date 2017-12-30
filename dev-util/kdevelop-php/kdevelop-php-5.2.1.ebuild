# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_BRANCH="5.2"
KDEBASE="kdevelop"
KDE_DOC_DIR="docs"
KDE_HANDBOOK="forceoptional"
KDE_TEST="forceoptional"
KMNAME="kdev-php"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="PHP plugin for KDevelop"
LICENSE="GPL-2 LGPL-2"
IUSE=""
[[ ${KDE_BUILD_TYPE} = release ]] && KEYWORDS="~amd64 x86"

COMMON_DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep ktexteditor)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep threadweaver)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	dev-util/kdevelop-pg-qt:5
	dev-util/kdevelop:5
"
RDEPEND="${COMMON_DEPEND}
	!dev-util/kdevelop-php-docs
"
DEPEND="${COMMON_DEPEND}
	test? ( dev-util/kdevelop:5[test] )
"

RESTRICT+=" test"
