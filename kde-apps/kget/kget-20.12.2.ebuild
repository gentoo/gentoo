# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
KFMIN=5.75.0
QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="Advanced download manager by KDE"
HOMEPAGE="https://apps.kde.org/en/kget"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="bittorrent gpg kde mms sqlite"

RDEPEND="
	>=app-crypt/qca-2.3.0:2
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtsql-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kcmutils-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/kdelibs4support-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/knotifyconfig-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	bittorrent? ( net-libs/libktorrent:5 )
	gpg? ( app-crypt/gpgme[qt5] )
	kde? ( kde-plasma/libkworkspace:5 )
	mms? ( media-libs/libmms )
	sqlite? ( dev-db/sqlite:3 )
"
DEPEND="${RDEPEND}
	dev-libs/boost
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package bittorrent KF5Torrent)
		$(cmake_use_find_package gpg Gpgmepp)
		$(cmake_use_find_package kde LibKWorkspace)
		$(cmake_use_find_package mms LibMms)
		$(cmake_use_find_package sqlite Sqlite)
	)

	ecm_src_configure
}

src_test() {
	# bug 756817: schedulertest fails, see also upstream commit 45735cfa
	# filedeletertest hangs.
	local myctestargs=(
		-E "(schedulertest|filedeletertest)"
	)

	ecm_src_test
}
