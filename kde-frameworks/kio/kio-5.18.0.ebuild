# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework providing transparent file and data management"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm ~x86"
IUSE="acl +handbook kerberos +kwallet X"

COMMON_DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kbookmarks)
	$(add_frameworks_dep kcodecs)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtscript:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-libs/libxml2
	dev-libs/libxslt
	acl? (
		sys-apps/attr
		virtual/acl
	)
	kerberos? ( virtual/krb5 )
	kwallet? ( $(add_frameworks_dep kwallet) )
	X? ( dev-qt/qtx11extras:5 )
"
DEPEND="${COMMON_DEPEND}
	dev-qt/qtconcurrent:5
	handbook? ( $(add_frameworks_dep kdoctools) )
	test? ( sys-libs/zlib )
	X? (
		x11-libs/libX11
		x11-libs/libXrender
		x11-proto/xproto
	)
"
PDEPEND="
	$(add_frameworks_dep kded)
"
RDEPEND="${COMMON_DEPEND}"

# tests hang
RESTRICT="test"

PATCHES=( "${FILESDIR}/${P}-ftp-timestamps.patch" )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package acl)
		$(cmake-utils_use_find_package handbook KF5DocTools)
		$(cmake-utils_use_find_package kerberos GSSAPI)
		$(cmake-utils_use_find_package kwallet KF5Wallet)
		$(cmake-utils_use_find_package X X11)
	)

	kde5_src_configure
}
