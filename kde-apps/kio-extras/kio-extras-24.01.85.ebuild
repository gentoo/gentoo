# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="optional"
KFMIN=5.247.0
QTMIN=6.6.0
inherit ecm gear.kde.org

DESCRIPTION="KIO plugins present a filesystem-like view of arbitrary data"
HOMEPAGE="https://invent.kde.org/network/kio-extras"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64"
IUSE="activities ios +man mtp openexr phonon +sftp taglib X"
# TODO: activities: collides with Plasma-5, plus:
# https://invent.kde.org/network/kio-extras/-/merge_requests/320
# TODO: samba (net-libs/kdsoap packaging issue w/ upstream)
# disabled upstream: nfs

# requires running Plasma environment
RESTRICT="test"

DEPEND="
	dev-libs/qcoro
	>=dev-qt/qt5compat-${QTMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets,xml]
	>=dev-qt/qtsvg-${QTMIN}:6
	kde-apps/libkexiv2:6
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcodecs-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kdnssd-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	>=kde-frameworks/syntax-highlighting-${KFMIN}:6
	activities? (
		>=dev-qt/qtbase-${QTMIN}:6[sql]
		kde-plasma/plasma-activities:6
		kde-plasma/plasma-activities-stats:6
	)
	ios? (
		app-pda/libimobiledevice:=
		app-pda/libplist:=
	)
	mtp? ( >=media-libs/libmtp-1.1.16:= )
	openexr? ( media-libs/openexr:= )
	phonon? ( >=media-libs/phonon-4.12.0[qt6] )
	sftp? ( net-libs/libssh:=[sftp] )
	taglib? ( >=media-libs/taglib-1.11.1 )
	X? (
		x11-libs/libX11
		x11-libs/libXcursor
	)
"
# 	nfs? ( net-libs/libtirpc:= )
# 	samba? (
# 		net-fs/samba[client]
# 		>=net-libs/kdsoap-2.1.1-r1:=
# 		>=net-libs/kdsoap-ws-discovery-client-0.3.0
# 	)
RDEPEND="${DEPEND}
	!<kde-apps/kio-extras-23.08.5-r100:5
	!kde-apps/kio-extras-kf5:5[-kf6compat]
	!kde-frameworks/kio:5[-kf6compat(-)]
	>=kde-frameworks/kded-${KFMIN}:6
"
BDEPEND="man? ( dev-util/gperf )"

PATCHES=( "${FILESDIR}/${P}-activities-optional.patch" )

src_configure() {
	local mycmakeargs=(
		-DBUILD_ACTIVITIES=$(usex activities)
		$(cmake_use_find_package ios IMobileDevice)
		$(cmake_use_find_package ios PList)
		$(cmake_use_find_package man Gperf)
		$(cmake_use_find_package mtp Libmtp)
# 		$(cmake_use_find_package nfs TIRPC)
		$(cmake_use_find_package openexr OpenEXR)
		$(cmake_use_find_package phonon Phonon4Qt6)
		-DCMAKE_DISABLE_FIND_PACKAGE_Samba=ON
		$(cmake_use_find_package sftp libssh)
		$(cmake_use_find_package taglib Taglib)
		-DWITHOUT_X11=$(usex !X)
	)

	ecm_src_configure
}
