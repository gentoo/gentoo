# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_TEST="forceoptional"
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 kde5

DESCRIPTION="KDE Interactive Geometry tool"
HOMEPAGE="https://www.kde.org/applications/education/kig https://edu.kde.org/kig"
KEYWORDS="amd64 ~x86"
IUSE="geogebra scripting"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	geogebra? ( $(add_qt_dep qtxmlpatterns) )
	scripting? ( >=dev-libs/boost-1.48:=[python,${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	$(add_frameworks_dep ktexteditor)
	test? (
		$(add_frameworks_dep kemoticons)
		$(add_frameworks_dep kitemmodels)
	)
"

PATCHES=( "${FILESDIR}/${PN}-4.12.0-boostpython.patch" )

pkg_setup() {
	python-single-r1_pkg_setup
	kde5_pkg_setup
}

src_prepare() {
	kde5_src_prepare
	python_fix_shebang .
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package geogebra Qt5XmlPatterns)
		$(cmake-utils_use_find_package scripting BoostPython)
		$(cmake-utils_use_find_package test KF5Emoticons)
		$(cmake-utils_use_find_package test KF5ItemModels)
	)

	kde5_src_configure
}
