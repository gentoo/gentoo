# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="optional"
KFMIN=5.63.0
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="KIO plugins present a filesystem-like view of arbitrary data"
HOMEPAGE="https://invent.kde.org/network/kio-extras"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
IUSE="activities +man mtp nfs openexr phonon samba +sftp taglib"

BDEPEND="
	man? ( dev-util/gperf )
"
DEPEND="
	>=kde-frameworks/karchive-${KFMIN}:5[bzip2,lzma]
	>=kde-frameworks/kbookmarks-${KFMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdnssd-${KFMIN}:5
	>=kde-frameworks/kguiaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kpty-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	>=kde-frameworks/syntax-highlighting-${KFMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	activities? (
		>=kde-frameworks/kactivities-${KFMIN}:5
		>=kde-frameworks/kactivities-stats-${KFMIN}:5
		>=dev-qt/qtsql-${QTMIN}:5
	)
	mtp? ( >=media-libs/libmtp-1.1.16:= )
	nfs? ( net-libs/libtirpc:= )
	openexr? ( media-libs/openexr:= )
	phonon? ( media-libs/phonon[qt5(+)] )
	samba? ( net-fs/samba[client] )
	sftp? ( net-libs/libssh:=[sftp] )
	taglib? ( >=media-libs/taglib-1.11.1 )
"
RDEPEND="${DEPEND}
	>=kde-frameworks/kded-${KFMIN}:5
"

# requires running kde environment
RESTRICT+=" test"

PATCHES=(
	"${FILESDIR}/${P}-kio_nfs.patch"
	"${FILESDIR}/${P}-CVE-2020-12755.patch" # bug 722152
)

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package activities KF5Activities)
		$(cmake_use_find_package activities KF5ActivitiesStats)
		$(cmake_use_find_package man Gperf)
		$(cmake_use_find_package mtp Mtp)
		$(cmake_use_find_package nfs TIRPC)
		$(cmake_use_find_package openexr OpenEXR)
		$(cmake_use_find_package phonon Phonon4Qt5)
		$(cmake_use_find_package samba Samba)
		$(cmake_use_find_package sftp libssh)
		$(cmake_use_find_package taglib Taglib)
	)

	ecm_src_configure
}
