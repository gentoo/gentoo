# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-3)
KFMIN=6.0.0
QTMIN=6.6.2
inherit ecm gear.kde.org

DESCRIPTION="KDE accounts providers"
HOMEPAGE="https://community.kde.org/KTp"

LICENSE="LGPL-2.1"
SLOT="6"
KEYWORDS="~amd64"
IUSE="+webengine"

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-apps/kaccounts-integration-${PVCUT}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kpackage-${KFMIN}:6
	webengine? ( >=dev-qt/qtwebengine-${QTMIN}:6 )
"
RDEPEND="${DEPEND}
	>=net-libs/signon-oauth2-0.25_p20210102[qt6]
	>=net-libs/signon-ui-0.15_p20231016
"
BDEPEND="dev-util/intltool"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package webengine Qt6WebEngineQuick)
	)
	ecm_src_configure
}
