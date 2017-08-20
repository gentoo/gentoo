# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="A collection manager based on KDE Frameworks"
HOMEPAGE="http://tellico-project.org/"
SRC_URI="http://tellico-project.org/files/${P}.tar.xz"

LICENSE="|| ( GPL-2 GPL-3 )"
KEYWORDS="amd64 x86"
IUSE="cddb discid pdf scanner semantic-desktop taglib v4l xmp yaz"

COMMON_DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep khtml)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kitemmodels)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	$(add_frameworks_dep sonnet)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	>=dev-perl/Text-BibTeX-0.780.0-r1
	dev-libs/libxml2
	dev-libs/libxslt
	cddb? ( $(add_kdeapps_dep libkcddb) )
	discid? ( media-libs/libdiscid )
	pdf? ( app-text/poppler[qt5] )
	scanner? ( $(add_kdeapps_dep libksane) )
	semantic-desktop? ( $(add_frameworks_dep kfilemetadata) )
	taglib? ( >=media-libs/taglib-1.5 )
	v4l? ( >=media-libs/libv4l-0.8.3 )
	xmp? ( >=media-libs/exempi-2 )
	yaz? ( >=dev-libs/yaz-2:0 )
"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
"
RDEPEND="${COMMON_DEPEND}
	!kde-misc/tellico:4
"

# tests need network access
RESTRICT="test"

DOCS=( AUTHORS ChangeLog README )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Csv=ON
		$(cmake-utils_use_find_package cddb KF5Cddb)
		$(cmake-utils_use_find_package discid DiscID)
		$(cmake-utils_use_find_package pdf PopplerQt5)
		$(cmake-utils_use_find_package scanner KF5Sane)
		$(cmake-utils_use_find_package semantic-desktop KF5FileMetaData)
		$(cmake-utils_use_find_package taglib Taglib)
		-DENABLE_WEBCAM=$(usex v4l)
		$(cmake-utils_use_find_package xmp Exempi)
		$(cmake-utils_use_find_package yaz Yaz)
	)

	kde5_src_configure
}
