# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PVCUT=$(ver_cut 1-3)
KFMIN=6.9.0
QTMIN=6.7.2
inherit ecm gear.kde.org xdg

DESCRIPTION="KDE accounts providers"
HOMEPAGE="https://community.kde.org/KTp"

LICENSE="LGPL-2.1"
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE=""

COMMON_DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtwebengine-${QTMIN}:6[qml]
	>=kde-apps/kaccounts-integration-${PVCUT}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kpackage-${KFMIN}:6
"
DEPEND="${COMMON_DEPEND}
	dev-libs/qcoro[network]
"
RDEPEND="${COMMON_DEPEND}
	>=net-libs/signon-oauth2-0.25_p20210102[qt6(+)]
	>=net-libs/signon-ui-0.15_p20231016
"
