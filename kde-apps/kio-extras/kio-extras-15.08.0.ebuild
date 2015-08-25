# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="true"
KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit fdo-mime kde5

DESCRIPTION="KIO plugins present a filesystem-like view of arbitrary data"
HOMEPAGE="https://projects.kde.org/projects/kde/workspace/kio-extras"
KEYWORDS="~amd64 ~x86"
IUSE="exif mtp phonon samba +sftp slp"

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
	$(add_frameworks_dep khtml)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kpty)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	virtual/jpeg:0
	exif? ( media-gfx/exiv2:= )
	mtp? ( media-libs/libmtp:= )
	phonon? ( media-libs/phonon[qt5] )
	samba? ( || ( <net-fs/samba-4.0.0_alpha1[smbclient] >=net-fs/samba-4.0.0_alpha1[client] ) )
	sftp? ( >=net-libs/libssh-0.6.0:=[sftp] )
	slp? ( net-libs/openslp )
"
RDEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kded)
	!kde-apps/kdebase-kioslaves:4[-minimal(-)]
	!kde-apps/kcontrol:4
	!kde-base/kdebase-kioslaves:4[-minimal(-)]
	!kde-base/kio-extras
	!kde-plasma/kio-extras
"
DEPEND="${COMMON_DEPEND}
	x11-misc/shared-mime-info
"

# requires running kde environment
RESTRICT="test"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package exif Exiv2)
		$(cmake-utils_use_find_package mtp)
		$(cmake-utils_use_find_package phonon Phonon4Qt5)
		$(cmake-utils_use_find_package samba)
		$(cmake-utils_use_find_package sftp LibSSH)
		$(cmake-utils_use_find_package slp)
	)

	kde5_src_configure
}

pkg_postinst() {
	kde5_pkg_postinst
	fdo-mime_mime_database_update
}

pkg_postrm() {
	kde5_pkg_postinst
	fdo-mime_mime_database_update
}
