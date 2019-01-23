# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_TEST="optional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="KIO plugins present a filesystem-like view of arbitrary data"
HOMEPAGE="https://cgit.kde.org/kio-extras.git"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${P}-sftp-18.11.80.patch.tar.xz"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="activities +man mtp openexr phonon samba +sftp taglib"

COMMON_DEPEND="
	$(add_frameworks_dep karchive 'bzip2,lzma')
	$(add_frameworks_dep kbookmarks)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
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
	activities? (
		$(add_frameworks_dep kactivities)
		$(add_qt_dep qtsql)
	)
	man? ( $(add_frameworks_dep khtml) )
	mtp? ( >=media-libs/libmtp-1.1.16:= )
	openexr? ( media-libs/openexr:= )
	phonon? ( media-libs/phonon[qt5(+)] )
	samba? ( net-fs/samba[client] )
	sftp? ( net-libs/libssh:=[sftp] )
	taglib? ( >=media-libs/taglib-1.11.1 )
"
RDEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kded)
"
DEPEND="${COMMON_DEPEND}
	x11-misc/shared-mime-info
	man? ( dev-util/gperf )
"

# requires running kde environment
RESTRICT+=" test"

PATCHES=( "${WORKDIR}/${P}-sftp-18.11.80.patch" )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5WebEngineWidgets=ON
		$(cmake-utils_use_find_package activities KF5Activities)
		$(cmake-utils_use_find_package man Gperf)
		$(cmake-utils_use_find_package mtp Mtp)
		$(cmake-utils_use_find_package openexr OpenEXR)
		$(cmake-utils_use_find_package phonon Phonon4Qt5)
		$(cmake-utils_use_find_package samba Samba)
		$(cmake-utils_use_find_package sftp libssh)
		$(cmake-utils_use_find_package taglib Taglib)
	)

	kde5_src_configure
}
