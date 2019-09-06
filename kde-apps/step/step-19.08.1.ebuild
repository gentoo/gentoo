# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="optional"
KDE_TEST="forceoptional"
inherit kde5

DESCRIPTION="Interactive physics simulator"
HOMEPAGE="https://edu.kde.org/step/"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+gsl nls +qalculate"

BDEPEND="
	nls? ( $(add_qt_dep linguist-tools) )
"
DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep khtml)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kplotting)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtopengl)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	>=dev-cpp/eigen-3.2:3
	sci-libs/cln
	gsl? ( sci-libs/gsl:= )
	qalculate? ( >=sci-libs/libqalculate-0.9.5:= )
"
RDEPEND="${DEPEND}"

src_prepare() {
	kde5_src_prepare

	# FIXME: Drop duplicate upstream
	sed -e '/find_package.*Xml Test/ s/^/#/' \
		-i stepcore/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package gsl GSL)
		$(cmake-utils_use_find_package qalculate Qalculate)
	)
	kde5_src_configure
}
