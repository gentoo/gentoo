# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PVCUT=$(ver_cut 1-3)
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="KDE accounts providers"
HOMEPAGE="https://community.kde.org/KTp"
LICENSE="LGPL-2.1"

SLOT="5"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE=""

BDEPEND="
	dev-util/intltool
"
DEPEND="
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kpackage-${KFMIN}:5
	>=kde-apps/kaccounts-integration-${PVCUT}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
"
RDEPEND="${DEPEND}
	net-libs/signon-ui
	net-libs/signon-oauth2
"
