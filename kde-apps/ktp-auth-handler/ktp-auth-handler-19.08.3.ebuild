# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PVCUT=$(ver_cut 1-3)
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="KDE Telepathy authentication handler"
HOMEPAGE="https://community.kde.org/Real-Time_Communication_and_Collaboration"

LICENSE="LGPL-2.1"
SLOT="5"
KEYWORDS="amd64 arm64 x86"
IUSE=""

DEPEND="
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-apps/kaccounts-integration-${PVCUT}:5
	>=kde-apps/ktp-common-internals-${PVCUT}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	app-crypt/qca:2[qt5(+)]
	net-libs/accounts-qt
	net-libs/signond
	net-libs/telepathy-qt[qt5(+)]
"
RDEPEND="${DEPEND}
	app-crypt/qca:2[ssl]
"
