# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_TEST="optional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="KIO plugins present a filesystem-like view of arbitrary data"
HOMEPAGE="https://projects.kde.org/projects/kde/workspace/kio-extras"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="activities exif +man mtp openexr phonon samba +sftp slp"

COMMON_DEPEND="
	$(add_frameworks_dep karchive 'bzip2,lzma')
	$(add_frameworks_dep kbookmarks)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep kdnssd)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kpty)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	virtual/jpeg:0
	activities? (
		$(add_frameworks_dep kactivities)
		$(add_qt_dep qtsql)
	)
	exif? ( media-gfx/exiv2:= )
	man? ( $(add_frameworks_dep khtml) )
	mtp? ( media-libs/libmtp:= )
	openexr? ( media-libs/openexr )
	phonon? ( media-libs/phonon[qt5] )
	samba? ( net-fs/samba[client] )
	sftp? ( net-libs/libssh:=[sftp] )
	slp? ( net-libs/openslp )
"
RDEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kded)
"
DEPEND="${COMMON_DEPEND}
	x11-misc/shared-mime-info
"

# requires running kde environment
RESTRICT+=" test"

PATCHES=(
	"${FILESDIR}/${PN}"-16.12.1-activities-optional.patch
	"${FILESDIR}/${PN}"-16.12.1-man-optional.patch
)

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package activities KF5Activities)
		$(cmake-utils_use_find_package exif Exiv2)
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebEngineWidgets=ON
		$(cmake-utils_use_find_package man KF5KHtml)
		$(cmake-utils_use_find_package mtp Mtp)
		$(cmake-utils_use_find_package openexr OpenEXR)
		$(cmake-utils_use_find_package phonon Phonon4Qt5)
		$(cmake-utils_use_find_package samba Samba)
		$(cmake-utils_use_find_package sftp LibSSH)
		$(cmake-utils_use_find_package slp SLP)
	)

	kde5_src_configure
}
