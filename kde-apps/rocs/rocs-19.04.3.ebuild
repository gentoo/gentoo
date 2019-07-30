# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
KDE_TEST="true"
inherit kde5

DESCRIPTION="Interface to work with Graph Theory"
HOMEPAGE="https://kde.org/applications/education/rocs
https://edu.kde.org/applications/mathematics/rocs"
KEYWORDS="amd64 arm64 x86"
IUSE=""

RDEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktexteditor)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtdeclarative 'widgets')
	$(add_qt_dep qtgui)
	$(add_qt_dep qtscript 'scripttools')
	$(add_qt_dep qtsvg)
	>=dev-qt/qtwebkit-5.212.0_pre20180120:5
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	$(add_qt_dep qtxmlpatterns)
	dev-libs/grantlee:5
"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.49
"

RESTRICT+=" test"	# 1/10 tests currently fails
