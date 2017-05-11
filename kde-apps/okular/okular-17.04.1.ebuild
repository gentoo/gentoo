# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Universal document viewer based on KDE Frameworks"
HOMEPAGE="https://okular.kde.org https://www.kde.org/applications/graphics/okular"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="chm crypt djvu ebook +image-backend mobi mobile +pdf plucker +postscript speech +tiff"

DEPEND="
	$(add_frameworks_dep kactivities)
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kbookmarks)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kjs)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kpty)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep threadweaver)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	media-libs/freetype
	media-libs/phonon[qt5]
	sys-libs/zlib
	chm? (
		$(add_frameworks_dep khtml)
		dev-libs/chmlib
	)
	crypt? ( app-crypt/qca:2[qt5] )
	djvu? ( app-text/djvu )
	ebook? ( app-text/ebook-tools )
	image-backend? (
		$(add_kdeapps_dep libkexiv2)
		$(add_qt_dep qtgui 'gif,jpeg,png')
	)
	mobi? ( $(add_kdeapps_dep kdegraphics-mobipocket) )
	pdf? ( app-text/poppler[qt5,-exceptions(-)] )
	plucker? ( virtual/jpeg:0 )
	postscript? ( app-text/libspectre )
	speech? ( $(add_qt_dep qtspeech) )
	tiff? ( media-libs/tiff:0 )
"
RDEPEND="${DEPEND}
	image-backend? ( $(add_frameworks_dep kimageformats) )
	mobile? ( dev-libs/kirigami:1 )
"

# bug 603116
RESTRICT+=" test"

src_prepare() {
	kde5_src_prepare
	use mobile || cmake_comment_add_subdirectory mobile
	use test || cmake_comment_add_subdirectory conf/autotests
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package chm CHM)
		$(cmake-utils_use_find_package crypt Qca-qt5)
		$(cmake-utils_use_find_package djvu DjVuLibre)
		$(cmake-utils_use_find_package ebook EPub)
		$(cmake-utils_use_find_package image-backend KF5KExiv2)
		$(cmake-utils_use_find_package mobi QMobipocket)
		$(cmake-utils_use_find_package pdf Poppler)
		$(cmake-utils_use_find_package plucker JPEG)
		$(cmake-utils_use_find_package postscript LibSpectre)
		$(cmake-utils_use_find_package speech Qt5TextToSpeech)
		$(cmake-utils_use_find_package tiff TIFF)
	)

	kde5_src_configure
}
