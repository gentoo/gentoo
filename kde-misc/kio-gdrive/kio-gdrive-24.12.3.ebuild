# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoff"
ECM_TEST="true"
KDE_ORG_CATEGORY="network"
KFMIN=6.7.0
QTMIN=6.7.2
inherit ecm gear.kde.org

DESCRIPTION="KIO worker for Google Drive service"
HOMEPAGE="https://apps.kde.org/kio_gdrive/"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE="+share"

COMMON_DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	kde-apps/kaccounts-integration:6
	kde-apps/libkgapi:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	share? ( >=kde-frameworks/purpose-${KFMIN}:6 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/qtbase-${QTMIN}:6[network]
"
RDEPEND="${COMMON_DEPEND}
	kde-apps/kaccounts-providers:6
	>=kde-misc/${PN}-common-${PV}
	share? ( !${CATEGORY}/${PN}:5[share,-kf6compat(-)] )
"
BDEPEND="dev-util/intltool"

DOCS=( README.md )

ECM_REMOVE_FROM_INSTALL=(
	/usr/share/accounts/services/kde/google-drive.service
	/usr/share/metainfo/org.kde.kio_gdrive.metainfo.xml
	/usr/share/remoteview/gdrive-network.desktop
)

src_prepare() {
	ecm_src_prepare
	ecm_punt_po_install
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package share KF6Purpose)
	)
	ecm_src_configure
}
