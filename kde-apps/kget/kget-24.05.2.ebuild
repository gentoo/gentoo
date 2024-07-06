# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
KFMIN=6.3.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="Advanced download manager by KDE"
HOMEPAGE="https://apps.kde.org/kget/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE="bittorrent gpg mms sqlite"

RDEPEND="
	>=app-crypt/qca-2.3.7:2[qt6]
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,sql,widgets,xml]
	>=kde-frameworks/kcmutils-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/knotifyconfig-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/kwallet-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	bittorrent? ( net-libs/libktorrent:6 )
	gpg? ( >=app-crypt/gpgme-1.23.1-r1:=[qt6] )
	mms? ( media-libs/libmms )
	sqlite? ( dev-db/sqlite:3 )
"
DEPEND="${RDEPEND}
	dev-libs/boost
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package bittorrent KTorrent6)
		$(cmake_use_find_package gpg Gpgmepp)
		$(cmake_use_find_package gpg QGpgmeQt6)
		$(cmake_use_find_package mms LibMms)
		$(cmake_use_find_package sqlite SQLite3)
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
