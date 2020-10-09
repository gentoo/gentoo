# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="optional"
KDE_ORG_CATEGORY="network"
KDE_RELEASE_SERVICE="true"
PVCUT=$(ver_cut 1-3)
KFMIN=5.72.0
QTMIN=5.14.2
inherit ecm kde.org

DESCRIPTION="KIO Slave for Google Drive service"
HOMEPAGE="https://kde.org/applications/internet/org.kde.kio_gdrive"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+kaccounts"

BDEPEND="dev-util/intltool"
RDEPEND="
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-apps/libkgapi-19.08.0:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	kaccounts? ( >=kde-apps/kaccounts-integration-${PVCUT}:5 )
	!kaccounts? ( dev-libs/qtkeychain:=[qt5(+)] )
"
DEPEND="${RDEPEND}
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
"

DOCS=( README.md )

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package kaccounts KAccounts)
	)
	ecm_src_configure
}
