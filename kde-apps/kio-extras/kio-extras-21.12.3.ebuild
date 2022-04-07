# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="optional"
KFMIN=5.88.0
QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="KIO plugins present a filesystem-like view of arbitrary data"
HOMEPAGE="https://invent.kde.org/network/kio-extras"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="activities +man mtp nfs openexr phonon samba +sftp taglib X"

# requires running Plasma environment
RESTRICT="test"

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kbookmarks-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdnssd-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	>=kde-frameworks/syntax-highlighting-${KFMIN}:5
	activities? (
		>=dev-qt/qtsql-${QTMIN}:5
		>=kde-frameworks/kactivities-${KFMIN}:5
		>=kde-frameworks/kactivities-stats-${KFMIN}:5
	)
	mtp? ( >=media-libs/libmtp-1.1.16:= )
	nfs? ( net-libs/libtirpc:= )
	openexr? ( media-libs/openexr:= )
	phonon? ( >=media-libs/phonon-4.11.0 )
	samba? (
		net-fs/samba[client]
		net-libs/kdsoap:=
		net-libs/kdsoap-ws-discovery-client
	)
	sftp? ( net-libs/libssh:=[sftp] )
	taglib? ( >=media-libs/taglib-1.11.1 )
	X? (
		x11-libs/libX11
		x11-libs/libXcursor
	)
"
RDEPEND="${DEPEND}
	>=kde-frameworks/kded-${KFMIN}:5
"
BDEPEND="man? ( dev-util/gperf )"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package activities KF5Activities)
		$(cmake_use_find_package activities KF5ActivitiesStats)
		$(cmake_use_find_package activities Qt5Sql)
		$(cmake_use_find_package man Gperf)
		$(cmake_use_find_package mtp Libmtp)
		$(cmake_use_find_package nfs TIRPC)
		$(cmake_use_find_package openexr OpenEXR)
		$(cmake_use_find_package phonon Phonon4Qt5)
		$(cmake_use_find_package samba Samba)
		$(cmake_use_find_package sftp libssh)
		$(cmake_use_find_package taglib Taglib)
		$(cmake_use_find_package X X11)
	)
	use samba && mycmakeargs+=(
		-DBUILD_KDSoapWSDiscoveryClient=OFF # disable bundled stuff
	)

	ecm_src_configure
}
